part of 'local_images_bloc.dart';

@immutable
abstract class LocalImagesEvent extends Equatable {
  const LocalImagesEvent();
}


class FetchLocalImages extends LocalImagesEvent {
  @override
  List<Object?> get props => [];
}





