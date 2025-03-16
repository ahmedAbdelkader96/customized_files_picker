import 'package:customized_files_picker/features/audios/bloc/android_audios_bloc.dart';
import 'package:customized_files_picker/features/audios/controller/controller.dart';
import 'package:customized_files_picker/features/images/bloc/local_images_bloc.dart';
import 'package:customized_files_picker/features/images/controller/controller.dart';
import 'package:customized_files_picker/features/main_view/bloc/pick_files_bloc.dart';
import 'package:customized_files_picker/features/main_view/controller/controller.dart';
import 'package:customized_files_picker/features/videos/bloc/local_videos_bloc.dart';
import 'package:customized_files_picker/features/videos/controller/controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlocProviders {
  static final List<BlocProvider> providers = [


    BlocProvider<PickFilesBloc>(
      create: (context) => PickFilesBloc(MainViewController()),
    ),



    BlocProvider<LocalImagesBloc>(
      create: (context) => LocalImagesBloc(LocalImagesController()),
    ),

    BlocProvider<LocalVideosBloc>(
      create: (context) => LocalVideosBloc(LocalVideosController()),
    ),

    BlocProvider<AndroidAudiosBloc>(
      create: (context) => AndroidAudiosBloc(LocalAndroidAudiosController()),
    ),




  ];
}
