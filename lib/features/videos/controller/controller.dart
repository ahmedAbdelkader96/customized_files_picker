 import 'package:customized_files_picker/features/videos/repository/repository.dart';


class LocalVideosController {
  final repo = LocalVideosRepository();



  Future<Map<String, dynamic>?> fetchLocalVideos() {
    return repo.fetchLocalVideos();
  }



}
