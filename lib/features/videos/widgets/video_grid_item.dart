import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:flutter/material.dart';


class VideoGridItem extends StatelessWidget {
  const VideoGridItem({super.key, required this.video});
  final VideoModel video;







  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(
          video.thumbnail,
          fit: BoxFit.cover,
        ),
        Positioned(bottom: 5,right: 5,child: Text(video.formattedVideoLength,maxLines: 1,
          style: TextStyle(
              fontSize: 11,fontWeight: FontWeight.w600,
              color: Colors.white
          ),))
      ],
    );
  }
}
