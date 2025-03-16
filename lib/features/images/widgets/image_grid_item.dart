import 'dart:io';

import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:flutter/material.dart';


class ImageGridItem extends StatelessWidget {
  const ImageGridItem({super.key, required this.imageModel });

  final ImageModel imageModel;

  @override
  Widget build(BuildContext context) {
    return Image.file(File(imageModel.path),fit: BoxFit.cover,);
  }
}
