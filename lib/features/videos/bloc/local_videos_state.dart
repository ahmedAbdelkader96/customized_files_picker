part of 'local_videos_bloc.dart';

abstract class LocalVideosState extends Equatable {
  const LocalVideosState();
}

class LocalVideosInitialState extends LocalVideosState {
  @override
  List<Object> get props => [];
}




class LoadingToFetchLocalVideosState extends LocalVideosState {
  @override
  List<Object> get props => [];
}
class DoneToFetchLocalVideosState extends LocalVideosState {
  final List<VideoModel> videos;
  final List<String> buckets;
  const DoneToFetchLocalVideosState({required this.videos,required this.buckets});

  @override
  List<Object> get props => [];
}
class ErrorToFetchLocalVideosState extends LocalVideosState {
  final String message;

  const ErrorToFetchLocalVideosState({required this.message});

  @override
  List<Object> get props => [];
}

