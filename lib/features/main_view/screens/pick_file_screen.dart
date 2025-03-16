import 'dart:io';

import 'package:customized_files_picker/features/audios/bloc/android_audios_bloc.dart';
import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:customized_files_picker/features/images/bloc/local_images_bloc.dart';
import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:customized_files_picker/features/main_view/bloc/pick_files_bloc.dart';
import 'package:customized_files_picker/features/videos/bloc/local_videos_bloc.dart';
import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/bottom_sheets_handler.dart';
import 'package:customized_files_picker/global/methods_helpers_utils/toast.dart';
import 'package:customized_files_picker/global/widgets/general_pick_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class PickFileScreen extends StatefulWidget {
  const PickFileScreen({super.key});

  @override
  _PickFileScreenState createState() => _PickFileScreenState();
}

class _PickFileScreenState extends State<PickFileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    init();

    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(milliseconds: 500);
  }

  Future<void> init() async {
    late PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else if (Platform.isAndroid) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      if (mounted) {
        context.read<LocalImagesBloc>().add(FetchLocalImages());
        context.read<LocalVideosBloc>().add(FetchLocalVideos());

        if (Platform.isAndroid) {
          context.read<AndroidAudiosBloc>().add(FetchAndroidAudios());
        }
      }
    } else if (status.isDenied) {
      print("Permission denied!");
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Files Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GeneralPickButton(
              onPressed: () async {
                ImageModel? image =
                await BottomSheetsHandler.pickImageBottomSheet(
                  context: context,
                  animationController: animationController,
                );
                if (image != null) {
                  ToastClass.toast(
                    context: context,
                    data: "Picked image Path : ${image.path}",
                    seconds: 3,
                  );
                }
              },
              title: "Pick Image",
            ),
            SizedBox(height: 30),


            GeneralPickButton(
              onPressed: () async {
                VideoModel? video =
                await BottomSheetsHandler.pickVideoBottomSheet(
                  context: context,
                  animationController: animationController,
                );
                if (video != null) {
                  ToastClass.toast(
                    context: context,
                    data: "Picked Video Path : ${video.path}",
                    seconds: 3,
                  );
                }
              },
              title: "Pick Video",
            ),
            SizedBox(height: 30),


            if (Platform.isAndroid)
              GeneralPickButton(
                onPressed: () async {
                  AudioModel? audio =
                  await BottomSheetsHandler.pickAndroidAudioBottomSheet(
                    context: context,
                    animationController: animationController,
                  );
                  if (audio != null) {
                    ToastClass.toast(
                      context: context,
                      data: "Picked Audio Path : ${audio.path}",
                      seconds: 3,
                    );
                  }
                },
                title: "Pick Audio",
              ),
            if (Platform.isAndroid)
              SizedBox(height: 30),





            BlocConsumer<PickFilesBloc, PickFilesState>(
              listener: (context, state) {
                if (state is ErrorToPickFilesState) {
                  ToastClass.toast(
                    context: context,
                    data: "${state.message}",
                    seconds: 3,
                  );
                }

                if (state is DoneToPickFilesState) {
                  ToastClass.toast(
                    context: context,
                    data: "Picked Files Paths : ${state.paths}",
                    seconds: 3,
                  );
                }
              },

              builder: (context, state) {
                return GeneralPickButton(
                  onPressed: () {
                    context.read<PickFilesBloc>().add(PickFiles());
                  },
                  title: "Pick Files",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}