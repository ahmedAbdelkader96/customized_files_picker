import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:customized_files_picker/global/widgets/general_buckets_list_item.dart';
import 'package:flutter/material.dart';

class ImageBucketsList extends StatelessWidget {
  const ImageBucketsList({
    super.key,
    required this.buckets,
    required this.images,
  });

  final List<String> buckets;
  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),
      itemBuilder: (context, index) {
        return GeneralBucketsListItem(
          title: buckets[index].toString(),
          number:
              images
                  .where((e) => e.bucket == buckets[index])
                  .toList()
                  .length,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount: buckets.length,
    );
  }
}
