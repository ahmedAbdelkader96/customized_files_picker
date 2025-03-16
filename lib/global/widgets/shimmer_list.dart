import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(
          top: MQuery.getheight(context, 24),
          right: MQuery.getWidth(context, 16),
          left: MQuery.getWidth(context, 16),
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.white,
            child: Container(
              width: MQuery.getWidth(context, 328),
              height: 60,
              color: Colors.grey[500], // The line color
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemCount: 50);
  }
}
