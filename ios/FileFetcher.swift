import Flutter
import UIKit
import Photos

public class FileFetcher: NSObject, FlutterPlugin, UIDocumentPickerDelegate {
    private var flutterResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let imageChannel = FlutterMethodChannel(name: "com.khedr.customized_files_picker/images", binaryMessenger: registrar.messenger())
        let videoChannel = FlutterMethodChannel(name: "com.khedr.customized_files_picker/videos", binaryMessenger: registrar.messenger())
        let filePickerChannel = FlutterMethodChannel(name: "com.khedr.customized_files_picker/file_picker", binaryMessenger: registrar.messenger())

        let instance = FileFetcher()
        registrar.addMethodCallDelegate(instance, channel: imageChannel)
        registrar.addMethodCallDelegate(instance, channel: videoChannel)
        registrar.addMethodCallDelegate(instance, channel: filePickerChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLocalImages":
            if let args = call.arguments as? [String: Any],
               let isAll = args["isAll"] as? Bool {
                let offset = args["offset"] as? Int ?? 0
                let limit = args["limit"] as? Int ?? 0
                fetchImages(result: result, isAll: isAll, offset: offset, limit: limit)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing isAll, offset, or limit", details: nil))
            }
        case "getLocalVideos":
            if let args = call.arguments as? [String: Any],
               let isAll = args["isAll"] as? Bool {
                let offset = args["offset"] as? Int ?? 0
                let limit = args["limit"] as? Int ?? 0
                fetchVideos(result: result, isAll: isAll, offset: offset, limit: limit)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing isAll, offset, or limit", details: nil))
            }
        case "openFilePicker":
            openFilePicker(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func fetchImages(result: @escaping FlutterResult, isAll: Bool, offset: Int, limit: Int) {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(with: fetchOptions)

            let paginatedAssets: [PHAsset]
            if isAll {
                paginatedAssets = assets.objects(at: IndexSet(integersIn: 0..<assets.count))
            } else {
                paginatedAssets = assets.objects(at: IndexSet(offset..<min(offset + limit, assets.count)))
            }

            var files: [[String: Any]] = []
            var buckets: Set<String> = []

            let dispatchGroup = DispatchGroup()

            for asset in paginatedAssets {
                dispatchGroup.enter()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .highQualityFormat

                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { (image, _) in
                    if let filePath = self.getFilePath(for: asset),
                       let fileName = asset.value(forKey: "filename") as? String {
                        let bucketName = self.getBucketName(for: asset)
                        files.append([
                            "filePath": filePath,
                            "bucket": bucketName,
                            "imageName": fileName
                        ])
                        buckets.insert(bucketName)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                result(["files": files, "buckets": Array(buckets)])
            }
        }
    }

    private func fetchVideos(result: @escaping FlutterResult, isAll: Bool, offset: Int, limit: Int) {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(with: fetchOptions)

            let paginatedAssets: [PHAsset]
            if isAll {
                paginatedAssets = assets.objects(at: IndexSet(integersIn: 0..<assets.count))
            } else {
                paginatedAssets = assets.objects(at: IndexSet(offset..<min(offset + limit, assets.count)))
            }

            var files: [[String: Any]] = []
            var buckets: Set<String> = []

            let dispatchGroup = DispatchGroup()

            for asset in paginatedAssets {
                dispatchGroup.enter()
                let options = PHVideoRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true

                PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
                    if let urlAsset = avAsset as? AVURLAsset {
                        let filePath = urlAsset.url.path
                        let bucketName = self.getBucketName(for: asset) // Use new method
                        let thumbnail = self.generateThumbnail(url: urlAsset.url)
                        let videoLength = self.getVideoLength(url: urlAsset.url)
                        let videoName = urlAsset.url.lastPathComponent
                        files.append([
                            "filePath": filePath,
                            "bucket": bucketName,
                            "thumbnail": thumbnail ?? Data(),
                            "videoLength": videoLength,
                            "videoName": videoName
                        ])
                        buckets.insert(bucketName)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                result(["files": files, "buckets": Array(buckets)])
            }
        }
    }

    private func getFilePath(for asset: PHAsset) -> String? {
        let options = PHContentEditingInputRequestOptions()
        var filePath: String?
        let semaphore = DispatchSemaphore(value: 0)
        asset.requestContentEditingInput(with: options) { input, _ in
            if let fullSizeImageURL = input?.fullSizeImageURL {
                filePath = fullSizeImageURL.path
            }
            semaphore.signal()
        }
        semaphore.wait()
        return filePath
    }

    private func getBucketName(for asset: PHAsset) -> String {
        // Fetch the collection of the asset
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var bucketName = "Unknown"

        collections.enumerateObjects { (collection, _, _) in
            let assetsInCollection = PHAsset.fetchAssets(in: collection, options: nil)
            if assetsInCollection.contains(asset) {
                bucketName = collection.localizedTitle ?? "Unknown"
            }
        }

        return bucketName
    }

    private func generateThumbnail(url: URL) -> Data? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: imageRef)
            return thumbnail.jpegData(compressionQuality: 0.8)
        } catch {
            return nil
        }
    }

    private func getVideoLength(url: URL) -> Int {
        let asset = AVAsset(url: url)
        return Int(CMTimeGetSeconds(asset.duration) * 1000)
    }

    private func openFilePicker(result: @escaping FlutterResult) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true // Allows multiple selection
        documentPicker.modalPresentationStyle = .formSheet

        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "NO_ROOT_VIEW_CONTROLLER", message: "No root view controller", details: nil))
            return
        }

        self.flutterResult = result
        rootViewController.present(documentPicker, animated: true, completion: nil)
    }

    // UIDocumentPickerDelegate methods
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let filePaths = urls.map { $0.path }
        if !filePaths.isEmpty {
            flutterResult?(filePaths)
        } else {
            flutterResult?(FlutterError(code: "NO_FILE_SELECTED", message: "No file selected", details: nil))
        }
        flutterResult = nil
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(FlutterError(code: "CANCELLED", message: "User cancelled document picker", details: nil))
        flutterResult = nil
    }
}