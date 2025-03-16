import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:customized_files_picker/features/images/widgets/image_grid_item.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class ImagesGrid extends StatefulWidget {
  const ImagesGrid({super.key, required this.images});
  final List<ImageModel> images;

  @override
  State<ImagesGrid> createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {

        return  ImageGridItem(imageModel: widget.images[index] );
      },
    );
  }
}
