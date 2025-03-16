import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:customized_files_picker/features/audios/repository/irepository.dart';
import 'package:flutter/services.dart';

class LocalAndroidAudiosRepository implements ILocalAndroidAudiosRepository {
  @override
  Future<Map<String, dynamic>?> fetchAndroidAudios() async {
    try {
      const platform = MethodChannel(
        'com.khedr.customized_files_picker/audios',
      );

      final Map<String, dynamic> arguments = {
        'offset': 0,
        'limit': 100,
        'isAll': false,
      };

      final fs = await platform.invokeMethod('getLocalAudios', arguments);

      List<AudioModel> audios =
          (fs['files'] as List).map((audio) {
            return AudioModel(
              path: audio['filePath'] as String,
              bucket: audio['bucket'] as String,
              audioName: audio['filePath'].split('/').last,
            );
          }).toList();

      List<String> buckets =
          (fs['buckets'] as List<dynamic>)
              .map((bucket) => bucket as String)
              .toList();

      return {'audios': audios, 'buckets': buckets};
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
