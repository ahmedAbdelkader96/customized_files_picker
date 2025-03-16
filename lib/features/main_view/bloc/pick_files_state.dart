part of 'pick_files_bloc.dart';

abstract class PickFilesState extends Equatable {
  const PickFilesState();
}

class PickFilesInitialState extends PickFilesState {
  @override
  List<Object> get props => [];
}

class LoadingToPickFilesState extends PickFilesState {
  @override
  List<Object> get props => [];
}

class DoneToPickFilesState extends PickFilesState {
  final List<String> paths;

  const DoneToPickFilesState({required this.paths});

  @override
  List<Object> get props => [];
}

class ErrorToPickFilesState extends PickFilesState {
  final String message;

  const ErrorToPickFilesState({required this.message});

  @override
  List<Object> get props => [];
}
