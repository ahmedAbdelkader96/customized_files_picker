import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Files Viewer',
      home: FileViewerScreen(),
    );
  }
}

class FileViewerScreen extends StatefulWidget {
  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  static const platform = MethodChannel('com.khedr.customized_files_picker/viewer');
  Future<List<dynamic>>? _filePathsFuture;

  Future<List<dynamic>> _getLocalFiles() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission not granted");
      }

      final List<dynamic> paths = await platform.invokeMethod('getLocalFiles');
      print("Files found: ${paths.length}");
      return paths;
    } on PlatformException catch (e) {
      print("Failed to get files: '${e.message}'.");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _filePathsFuture = _getLocalFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Files Viewer'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _filePathsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No files found'));
          } else {
            final filePaths = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: filePaths.length,
              itemBuilder: (context, index) {
                final file = File(filePaths[index]);
                final fileExtension = file.path.split('.').last.toLowerCase();
                if (['jpg', 'jpeg', 'png', 'gif' , 'webp'].contains(fileExtension)) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (['mp4', 'avi', 'mkv'].contains(fileExtension)) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Video"),
                  );
                } else if (['mp3', 'wav', 'aac'].contains(fileExtension)) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("audio"),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:  Text(fileExtension),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}