import 'package:customized_files_picker/features/videos/controller/controller.dart';
import 'package:customized_files_picker/features/videos/models/video_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'local_videos_event.dart';
part 'local_videos_state.dart';

class LocalVideosBloc extends Bloc<LocalVideosEvent, LocalVideosState> {
  final LocalVideosController controller;

  static LocalVideosBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }

  LocalVideosBloc(this.controller) : super(LocalVideosInitialState()) {
    on<FetchLocalVideos>((event, emit) async {
      try {
        emit(LoadingToFetchLocalVideosState());

        Map<String, dynamic>? data = await controller.fetchLocalVideos();
        if (data != null) {
          List<VideoModel> videos = data['videos'];
          List<String> buckets = data['buckets'];

          emit(DoneToFetchLocalVideosState(videos: videos, buckets: buckets));
        }
      } catch (e) {
        emit(ErrorToFetchLocalVideosState(message: e.toString()));
      }
    });
  }
}
