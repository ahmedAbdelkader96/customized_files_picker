import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';

class ToastClass{
  static void toast({required BuildContext context,required  String data,required  int seconds}){
    showPlatformToast(
      //duration: Duration(milliseconds: 2000),
      duration: Duration(seconds: seconds),

      child: Text(data),
      context: context,
      alignment:Alignment.center,
    );

  }
}