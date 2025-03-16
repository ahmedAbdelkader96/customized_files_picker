import 'package:customized_files_picker/features/main_view/repository/irepository.dart';
import 'package:flutter/services.dart';

class MainViewRepository implements IMainViewRepository {
  @override
  Future<List<String>?> pickFiles() async {
    try {
      const platform = MethodChannel(
        'com.khedr.customized_files_picker/file_picker',
      );

      final List<dynamic>? filePaths = await platform.invokeMethod(
        'openFilePicker',
      );

      if (filePaths != null) {
        return filePaths.map((file) => file.toString()).toList();
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}
