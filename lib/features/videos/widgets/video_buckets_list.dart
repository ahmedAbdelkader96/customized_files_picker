import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:customized_files_picker/global/widgets/general_buckets_list_item.dart';
import 'package:flutter/material.dart';

class VideoBucketsList extends StatelessWidget {
  const VideoBucketsList({super.key, required this.buckets, required this.videos});
  final List<String> buckets;
  final List<VideoModel> videos ;

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),
      itemBuilder: (context, index) {
        return GeneralBucketsListItem(
          title: buckets[index].toString(),
          number:
          videos
              .where((e) => e.path.contains(buckets[index]))
              .toList()
              .length,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount:  buckets.length,
    );
  }
}
