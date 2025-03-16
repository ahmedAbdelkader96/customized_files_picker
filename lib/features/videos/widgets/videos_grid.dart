import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:customized_files_picker/features/videos/widgets/video_grid_item.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class VideosGrid extends StatelessWidget {
  const VideosGrid({super.key, required this.videos});
  final List<VideoModel> videos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),
      gridDelegate:
      SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 100,
          maxCrossAxisExtent: 120
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {

        return  VideoGridItem(video: videos[index]);
      },
    );
  }
}
