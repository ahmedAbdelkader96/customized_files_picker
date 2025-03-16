import 'package:customized_files_picker/features/audios/repository/repository.dart';


class LocalAndroidAudiosController {
  final repo = LocalAndroidAudiosRepository();



  Future<Map<String, dynamic>?> fetchAndroidAudios() {
    return repo.fetchAndroidAudios();
  }




}
