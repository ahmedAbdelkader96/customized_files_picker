import 'package:customized_files_picker/features/images/controller/controller.dart';
import 'package:customized_files_picker/features/images/models/image_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'local_images_event.dart';
part 'local_images_state.dart';

class LocalImagesBloc extends Bloc<LocalImagesEvent, LocalImagesState> {
  final LocalImagesController controller;

  static LocalImagesBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }

  LocalImagesBloc(this.controller) : super(LocalImagesInitialState()) {
    on<FetchLocalImages>((event, emit) async {
      try {
        emit(LoadingToFetchLocalImagesState());





        Map<String, dynamic>? data = await controller.fetchLocalImages();
        if (data != null) {


           List<ImageModel> images = data['images']  ;
          List<String> buckets = data['buckets'];



          emit(DoneToFetchLocalImagesState(images: images, buckets: buckets));
        }

      } catch (e) {
        print("ErrorToFetchLocalImagesState is ${e.toString()}");
        emit(ErrorToFetchLocalImagesState(message: e.toString()));
      }
    });




  }
}
