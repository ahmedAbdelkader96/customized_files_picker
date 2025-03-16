import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:customized_files_picker/features/audios/widgets/audios_list_item.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class AudiosList extends StatelessWidget {
  const AudiosList({super.key, required this.audios});
  final List<AudioModel> audios;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),
      itemBuilder: (context, index) {
        return AudiosListItem(audio: audios[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount: audios.length,
    );
  }
}
