import 'package:customized_files_picker/features/audios/bloc/android_audios_bloc.dart';
import 'package:customized_files_picker/features/audios/widgets/audio_buckets_list.dart';
import 'package:customized_files_picker/features/audios/widgets/audios_list.dart';
import 'package:customized_files_picker/global/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

import '../../../global/methods_helpers_utils/media_query.dart';

class PickAndroidAudioBottomSheet extends StatefulWidget {
  const PickAndroidAudioBottomSheet({super.key});

  @override
  State<PickAndroidAudioBottomSheet> createState() =>
      _PickAndroidAudioBottomSheetState();
}

class _PickAndroidAudioBottomSheetState
    extends State<PickAndroidAudioBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController =  TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MQuery.getheight(context, 600),
      child: Column(
        children: [
          SizedBox(height: MQuery.getheight(context, 11)),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.red,
                    tabs: <Widget>[Tab(text: 'Audios'), Tab(text: 'Albums')],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  SizedBox(
                    height: MQuery.getheight(context, 500),
                    child: BlocBuilder<AndroidAudiosBloc, AndroidAudiosState>(
                      builder: (context, state) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            state is ErrorToFetchAndroidAudiosState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchAndroidAudiosState
                                ? AudiosList(audios: state.audios)
                                : ShimmerList(),



                            state is ErrorToFetchAndroidAudiosState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchAndroidAudiosState
                                ? AudioBucketsList(
                              buckets: state.buckets,
                              audios: state.audios,
                            )
                                : ShimmerList(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
         ],
      ),
    );
  }
}
