


import 'dart:typed_data';



class VideoModel {
  final String path;
  final Uint8List thumbnail;
  final String videoName;
  final int videoLength;
  final String bucket;

  VideoModel({
    required this.path,
    required this.thumbnail,
    required this.videoName  ,
    required this.videoLength  ,
    required this.bucket  ,

  } );

  // Method to convert video length to hours:min:sec format
  String get formattedVideoLength {
    final duration = Duration(milliseconds: videoLength);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

}
