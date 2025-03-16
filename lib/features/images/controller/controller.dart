

import 'package:customized_files_picker/features/images/repository/repository.dart';

class LocalImagesController {
  final repo = LocalImagesRepository();

  Future<Map<String, dynamic>?> fetchLocalImages() {
    return repo.fetchLocalImages();
  }




}
