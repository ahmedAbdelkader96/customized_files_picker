import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class AudiosListItem extends StatelessWidget {
  const AudiosListItem({super.key, required this.audio});

  final AudioModel audio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MQuery.getWidth(context, 328),
      height: 60,
      // padding: EdgeInsets.symmetric(horizontal: MQuery.getWidth(context, 16)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(

        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.amber,
            ),
            child: Icon(Icons.music_note,size: 14,color: Colors.white,),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              audio.audioName,
              overflow: TextOverflow.ellipsis,
                maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
