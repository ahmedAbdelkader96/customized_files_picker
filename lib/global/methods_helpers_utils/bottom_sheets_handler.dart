import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:customized_files_picker/features/audios/widgets/pick_android_audio_bottom_sheet.dart';
import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:customized_files_picker/features/images/widgets/pick_image_bottom_sheet.dart';
import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:customized_files_picker/features/videos/widgets/pick_video_bottom_sheet.dart';
import 'package:flutter/material.dart';


class BottomSheetsHandler {
  static Future<ImageModel?> pickImageBottomSheet({
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    ImageModel? res = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      transitionAnimationController: animationController,
      context: context,
      builder: (context) {
        return PickImageBottomSheet();
      },
    );
    if (res != null) {
      return res;
    }
    return null;
  }

  static Future<VideoModel?> pickVideoBottomSheet({
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    VideoModel? res = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      transitionAnimationController: animationController,
      context: context,
      builder: (context) {
        return PickVideoBottomSheet();
      },
    );
    if (res != null) {
      return res;
    }
    return null;
  }

  static Future<AudioModel?> pickAndroidAudioBottomSheet({
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    AudioModel? res = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      transitionAnimationController: animationController,
      context: context,
      builder: (context) {
        return PickAndroidAudioBottomSheet();
      },
    );
    if (res != null) {
      return res;
    }
    return null;
  }
}
