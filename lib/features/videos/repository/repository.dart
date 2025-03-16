import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:customized_files_picker/features/videos/repository/irepository.dart';
import 'package:flutter/services.dart';

class LocalVideosRepository implements ILocalVideosRepository {
  @override
  Future<Map<String, dynamic>?> fetchLocalVideos() async {
    try {
      const platform = MethodChannel(
        'com.khedr.customized_files_picker/videos',
      );

      final Map<String, dynamic> arguments = {
        'offset': 0,
        'limit': 100,
        'isAll': false,
      };

      final fs = await platform.invokeMethod('getLocalVideos', arguments);

      List<VideoModel> videos =
          (fs['files'] as List).map((video) {
            return VideoModel(
              path: video['filePath'] as String,
              thumbnail: video['thumbnail'] as Uint8List,
              videoName: video['videoName'] as String,
              videoLength: video['videoLength'] as int,
              bucket: video['bucket'] as String,

            );
          }).toList();

      List<String> buckets =
          (fs['buckets'] as List<dynamic>)
              .map((bucket) => bucket as String)
              .toList();

      return {'videos': videos, 'buckets': buckets};
    } catch (e) {
       throw Exception("Failed to get Images: '$e'.");

    }
  }
}
