import 'package:customized_files_picker/features/audios/controller/controller.dart';
import 'package:customized_files_picker/features/audios/models/audio_name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'android_audios_event.dart';
part 'android_audios_state.dart';

class AndroidAudiosBloc extends Bloc<AndroidAudiosEvent, AndroidAudiosState> {
  final LocalAndroidAudiosController controller;

  static AndroidAudiosBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }

  AndroidAudiosBloc(this.controller) : super(AndroidAudiosInitialState()) {
    on<FetchAndroidAudios>((event, emit) async {
      try {
        emit(LoadingToFetchAndroidAudiosState());

        Map<String, dynamic>? data = await controller.fetchAndroidAudios();
        if (data != null) {
          List<AudioModel> audios = data['audios'];
          List<String> buckets = data['buckets'];

          emit(DoneToFetchAndroidAudiosState(audios: audios, buckets: buckets));
        }
      } catch (e) {
        emit(ErrorToFetchAndroidAudiosState(message: e.toString()));
      }
    });
  }
}
