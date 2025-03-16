import 'package:customized_files_picker/features/videos/bloc/local_videos_bloc.dart';
import 'package:customized_files_picker/features/videos/widgets/video_buckets_list.dart';
import 'package:customized_files_picker/features/videos/widgets/videos_grid.dart';
import 'package:customized_files_picker/global/widgets/shimmer_grid.dart';
import 'package:customized_files_picker/global/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

import '../../../global/methods_helpers_utils/media_query.dart';

class PickVideoBottomSheet extends StatefulWidget {
  const PickVideoBottomSheet({super.key});

  @override
  State<PickVideoBottomSheet> createState() => _PickVideoBottomSheetState();
}

class _PickVideoBottomSheetState extends State<PickVideoBottomSheet>  with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    tabs: <Widget>[Tab(text: 'Videos'), Tab(text: 'Albums')],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  SizedBox(
                    height: MQuery.getheight(context, 500),
                    child: BlocBuilder<LocalVideosBloc, LocalVideosState>(
                      builder: (context, state) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            state is ErrorToFetchLocalVideosState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchLocalVideosState
                                ? VideosGrid(videos: state.videos)
                                : ShimmerGrid(),

                            state is ErrorToFetchLocalVideosState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchLocalVideosState
                                ? VideoBucketsList(buckets: state.buckets, videos: state.videos)
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
