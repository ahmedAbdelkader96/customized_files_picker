import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MQuery.getheight(context, 24),
        right: MQuery.getWidth(context, 16),
        left: MQuery.getWidth(context, 16),
      ),

      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: 100,
          maxCrossAxisExtent: 120
      ),
      itemCount: 50,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.white,
          child: Container(
            // width: MQuery.getWidth(context, 340),
            // height: 250,
            color: Colors.grey[500], // The line color
          ),
        );
      },
    );
  }
}
