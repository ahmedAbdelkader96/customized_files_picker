package com.khedr.customized_files_picker

import android.app.Activity
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Bundle
import android.provider.DocumentsContract
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.Future

class MainActivity : FlutterActivity() {
    private val IMAGE_CHANNEL = "com.khedr.customized_files_picker/images"
    private val VIDEO_CHANNEL = "com.khedr.customized_files_picker/videos"
    private val AUDIO_CHANNEL = "com.khedr.customized_files_picker/audios"
    private val DOCUMENT_CHANNEL = "com.khedr.customized_files_picker/file_picker"
    private val executor = Executors.newFixedThreadPool(8)  // Increase the number of threads
    private val PICK_DOCUMENT_REQUEST_CODE = 1002

    private lateinit var resultChannel: MethodChannel.Result
    private var channelsInitialized = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setupMethodChannels(flutterEngine!!)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Do not call setupMethodChannels here to avoid duplicate setup
    }

    private fun setupMethodChannels(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, IMAGE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalImages") {
                if (channelsInitialized) {
                    val isAll = call.argument<Boolean>("isAll") ?: false
                    val offset = call.argument<Int>("offset") ?: 0
                    val limit = call.argument<Int>("limit") ?: 100
                    fetchMediaFiles(result, MediaStore.Images.Media.EXTERNAL_CONTENT_URI, isAll, offset, limit)
                } else {
                    result.error("ChannelNotInitialized", "The method channel is not initialized.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(messenger, VIDEO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalVideos") {
                if (channelsInitialized) {
                    val isAll = call.argument<Boolean>("isAll") ?: false
                    val offset = call.argument<Int>("offset") ?: 0
                    val limit = call.argument<Int>("limit") ?: 100
                    fetchMediaFiles(result, MediaStore.Video.Media.EXTERNAL_CONTENT_URI, isAll, offset, limit, true)
                } else {
                    result.error("ChannelNotInitialized", "The method channel is not initialized.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(messenger, AUDIO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalAudios") {
                if (channelsInitialized) {
                    val isAll = call.argument<Boolean>("isAll") ?: false
                    val offset = call.argument<Int>("offset") ?: 0
                    val limit = call.argument<Int>("limit") ?: 100
                    fetchMediaFiles(result, MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, isAll, offset, limit)
                } else {
                    result.error("ChannelNotInitialized", "The method channel is not initialized.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(messenger, DOCUMENT_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openFilePicker") {
                if (channelsInitialized) {
                    resultChannel = result
                    openFilePicker()
                } else {
                    result.error("ChannelNotInitialized", "The method channel is not initialized.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        channelsInitialized = true
    }

    private fun fetchMediaFiles(result: MethodChannel.Result, uri: Uri, isAll: Boolean, offset: Int, limit: Int, isVideo: Boolean = false) {
        executor.execute {
            val projection = mutableListOf(MediaStore.MediaColumns.DATA)
            var bucketColumnExists = false

            // Check if the bucket_display_name column exists
            val tempCursor = contentResolver.query(uri, null, null, null, null)
            tempCursor?.use {
                bucketColumnExists = it.columnNames.contains(MediaStore.MediaColumns.BUCKET_DISPLAY_NAME)
            }

            if (bucketColumnExists) {
                projection.add(MediaStore.MediaColumns.BUCKET_DISPLAY_NAME)
            }

            val cursor = contentResolver.query(uri, projection.toTypedArray(), null, null, null)
            val files = mutableListOf<Map<String, Any?>>()
            val buckets = mutableSetOf<String>()

            cursor?.use {
                val dataIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA)
                val bucketIndex = if (bucketColumnExists) cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.BUCKET_DISPLAY_NAME) else null
                var count = 0
                val futures = mutableListOf<Future<Unit>>()

                while (cursor.moveToNext()) {
                    if (isAll || (count >= offset && count < offset + limit)) {
                        val filePath = cursor.getString(dataIndex)
                        val bucketName = bucketIndex?.let { cursor.getString(it) }
                        val fileMap = mutableMapOf<String, Any?>("filePath" to filePath, "bucket" to bucketName)
                        if (isVideo) {
                            futures.add(executor.submit<Unit> {
                                val thumbnail = getVideoThumbnail(filePath)
                                val videoLength = getVideoLength(filePath)
                                val videoName = getVideoName(filePath)
                                fileMap["thumbnail"] = thumbnail
                                fileMap["videoLength"] = videoLength
                                fileMap["videoName"] = videoName
                            })
                        }
                        files.add(fileMap)
                        bucketName?.let { buckets.add(it) }
                    }
                    count++
                    if (!isAll && count >= offset + limit) break
                }

                // Wait for all thumbnail generation tasks to complete
                futures.forEach { it.get() }
            }

            runOnUiThread {
                if (files.isNotEmpty()) {
                    result.success(mapOf("files" to files, "buckets" to buckets.toList()))
                } else {
                    result.success(mapOf("files" to emptyList<Map<String, Any?>>(), "buckets" to emptyList<String>())) // Return an empty list if no files found
                }
            }
        }
    }

    private fun getVideoThumbnail(path: String): ByteArray? {
        val bitmap = ThumbnailUtils.createVideoThumbnail(path, MediaStore.Video.Thumbnails.MINI_KIND)
        return bitmap?.let { bitmapToByteArray(it) }
    }

    private fun getVideoLength(path: String): Long {
        val retriever = MediaMetadataRetriever()
        retriever.setDataSource(path)
        val time = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
        retriever.release()
        return time?.toLong() ?: 0L
    }

    private fun getVideoName(path: String): String {
        return File(path).name
    }

    private fun bitmapToByteArray(bitmap: Bitmap): ByteArray {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
        return stream.toByteArray()
    }

    private fun openFilePicker() {
        // Create an intent to open the document picker
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }
        startActivityForResult(intent, PICK_DOCUMENT_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_DOCUMENT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val clipData = data?.clipData
            val selectedFiles = mutableListOf<Uri>()

            if (clipData != null) {
                for (i in 0 until clipData.itemCount) {
                    selectedFiles.add(clipData.getItemAt(i).uri)
                }
            } else {
                data?.data?.let { uri ->
                    selectedFiles.add(uri)
                }
            }

            // Handle the selected files
            handleSelectedFiles(selectedFiles)
        }
    }

    private fun handleSelectedFiles(selectedFiles: List<Uri>) {
        // Convert content URIs to file paths
        val filePaths = selectedFiles.mapNotNull { uri -> getPathFromUri(this, uri) }
        runOnUiThread {
            resultChannel.success(filePaths) // Return the selected file paths
        }
    }

    private fun getPathFromUri(context: Context, uri: Uri): String? {
        // DocumentProvider
        if (DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                val docId = DocumentsContract.getDocumentId(uri)
                val split = docId.split(":").toTypedArray()
                val type = split[0]
                if ("primary".equals(type, ignoreCase = true)) {
                    return context.getExternalFilesDir(null)?.absolutePath + "/" + split[1]
                }
            } else if (isDownloadsDocument(uri)) {
                val id = DocumentsContract.getDocumentId(uri)
                val contentUri = ContentUris.withAppendedId(
                    Uri.parse("content://downloads/public_downloads"), java.lang.Long.valueOf(id)
                )
                return getDataColumn(context, contentUri, null, null)
            } else if (isMediaDocument(uri)) {
                val docId = DocumentsContract.getDocumentId(uri)
                val split = docId.split(":").toTypedArray()
                val type = split[0]
                var contentUri: Uri? = null
                when (type) {
                    "image" -> contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    "video" -> contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                    "audio" -> contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                }
                val selection = "_id=?"
                val selectionArgs = arrayOf(split[1])
                return getDataColumn(context, contentUri, selection, selectionArgs)
            }
        } else if ("content".equals(uri.scheme, ignoreCase = true)) {
            // Return the remote address
            return getDataColumn(context, uri, null, null)
        } else if ("file".equals(uri.scheme, ignoreCase = true)) {
            return uri.path
        }
        return null
    }

    private fun getDataColumn(context: Context, uri: Uri?, selection: String?, selectionArgs: Array<String>?): String? {
        var cursor: Cursor? = null
        val column = "_data"
        val projection = arrayOf(column)
        try {
            cursor = context.contentResolver.query(uri!!, projection, selection, selectionArgs, null)
            if (cursor != null && cursor.moveToFirst()) {
                val columnIndex = cursor.getColumnIndexOrThrow(column)
                return cursor.getString(columnIndex)
            }
        } finally {
            cursor?.close()
        }
        return null
    }

    private fun isExternalStorageDocument(uri: Uri): Boolean {
        return "com.android.externalstorage.documents" == uri.authority
    }

    private fun isDownloadsDocument(uri: Uri): Boolean {
        return "com.android.providers.downloads.documents" == uri.authority
    }

    private fun isMediaDocument(uri: Uri): Boolean {
        return "com.android.providers.media.documents" == uri.authority
    }
}