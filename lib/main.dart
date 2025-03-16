
import 'package:customized_files_picker/features/main_view/screens/pick_file_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'global/bloc_providers/bloc_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: MaterialApp(
        title: "Local Files Picker",
        debugShowCheckedModeBanner: false,
          home: PickFileScreen()
      ),
    );
  }
}


