part of 'local_videos_bloc.dart';

@immutable
abstract class LocalVideosEvent extends Equatable {
  const LocalVideosEvent();
}


class FetchLocalVideos extends LocalVideosEvent {
  @override
  List<Object?> get props => [];
}





