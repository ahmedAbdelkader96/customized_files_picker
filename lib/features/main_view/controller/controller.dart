

import 'package:customized_files_picker/features/main_view/repository/repository.dart';

class MainViewController {
  final repo = MainViewRepository();




  Future<List<String>?> pickFiles(){
    return repo.pickFiles();
  }


}
