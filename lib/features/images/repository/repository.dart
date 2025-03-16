import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:customized_files_picker/features/images/repository/irepository.dart';
import 'package:flutter/services.dart';

class LocalImagesRepository implements ILocalImagesRepository {
  @override
  Future<Map<String, dynamic>?> fetchLocalImages() async {
    try {
      const platform = MethodChannel(
        'com.khedr.customized_files_picker/images',
      );

      final Map<String, dynamic> arguments = {
        'offset': 0,
        'limit': 10,
        'isAll': false,
      };

      final fs = await platform.invokeMethod('getLocalImages', arguments);


      List<ImageModel> images =
          (fs['files'] as List<dynamic>).map((image) {
            return ImageModel(
              path: image['filePath'] as String,
              bucket: image['bucket'] as String,
              imageName: image['filePath'].split('/').last,
            );
          }).toList();

      List<String> buckets =
          (fs['buckets'] as List<dynamic>)
              .map((bucket) => bucket as String)
              .toList();

      return {'images': images, 'buckets': buckets};
    } catch (e) {
      throw Exception("Failed to get Images: '${e}'.");
    }
  }
}
