part of 'local_images_bloc.dart';

abstract class LocalImagesState extends Equatable {
  const LocalImagesState();
}

class LocalImagesInitialState extends LocalImagesState {
  @override
  List<Object> get props => [];
}




class LoadingToFetchLocalImagesState extends LocalImagesState {
  @override
  List<Object> get props => [];
}
class DoneToFetchLocalImagesState extends LocalImagesState {
  final List<ImageModel> images;

  final List<String> buckets;
  const DoneToFetchLocalImagesState({required this.images,required this.buckets});


  @override
  List<Object> get props => [];
}
class ErrorToFetchLocalImagesState extends LocalImagesState {
  final String message;

  const ErrorToFetchLocalImagesState({required this.message});

  @override
  List<Object> get props => [];
}

