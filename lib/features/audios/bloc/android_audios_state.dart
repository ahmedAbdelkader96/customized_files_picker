part of 'android_audios_bloc.dart';

abstract class AndroidAudiosState extends Equatable {
  const AndroidAudiosState();
}

class AndroidAudiosInitialState extends AndroidAudiosState {
  @override
  List<Object> get props => [];
}




class LoadingToFetchAndroidAudiosState extends AndroidAudiosState {
  @override
  List<Object> get props => [];
}
class DoneToFetchAndroidAudiosState extends AndroidAudiosState {
  final List<AudioModel> audios;
  final List<String> buckets;
  const DoneToFetchAndroidAudiosState({required this.audios,required this.buckets});

  @override
  List<Object> get props => [];
}
class ErrorToFetchAndroidAudiosState extends AndroidAudiosState {
  final String message;

  const ErrorToFetchAndroidAudiosState({required this.message});

  @override
  List<Object> get props => [];
}

