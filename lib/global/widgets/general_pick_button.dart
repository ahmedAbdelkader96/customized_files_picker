import 'package:customized_files_picker/global/methods_helpers_utils/media_query.dart';
import 'package:flutter/material.dart';

class GeneralPickButton extends StatelessWidget {
  const GeneralPickButton({super.key, required this.onPressed, required this.title});
  final Function() onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      constraints: BoxConstraints(
        minWidth: MQuery.getWidth(context, 328),
        minHeight: 60
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)
      ),
      fillColor: Colors.amber,
      onPressed:  onPressed,
      child: Text(title,
      style: TextStyle(
        fontSize: 16,fontWeight: FontWeight.w700,
        color: Colors.white
      ),),
    );
  }
}
