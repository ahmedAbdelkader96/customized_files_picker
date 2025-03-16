import 'package:customized_files_picker/features/main_view/controller/controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pick_files_event.dart';
part 'pick_files_state.dart';

class PickFilesBloc extends Bloc<PickFilesEvent, PickFilesState> {
  final MainViewController controller;

  static PickFilesBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }

  PickFilesBloc(this.controller) : super(PickFilesInitialState()) {
    on<PickFiles>((event, emit) async {
      try {
        emit(LoadingToPickFilesState());

        List<String>? paths = await controller.pickFiles();
        if (paths != null) {
          emit(DoneToPickFilesState(paths: paths));
        } else {
          emit(ErrorToPickFilesState(message: "Cancelled !"));
        }
      } catch (e) {
        emit(ErrorToPickFilesState(message: e.toString()));
      }
    });
  }
}
