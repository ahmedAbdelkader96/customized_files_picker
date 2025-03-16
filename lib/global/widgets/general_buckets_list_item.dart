import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class GeneralBucketsListItem extends StatelessWidget {
  const GeneralBucketsListItem({super.key, required this.title, required this.number});
  final String title;
  final int number ;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MQuery.getWidth(context, 328),
      height: 60,
      padding: EdgeInsets.symmetric(
        horizontal: MQuery.getWidth(context, 16),
      ),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            "($number)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
