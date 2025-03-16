import 'package:customized_files_picker/features/images/bloc/local_images_bloc.dart';
import 'package:customized_files_picker/features/images/widgets/images_buckets_list.dart';
import 'package:customized_files_picker/features/images/widgets/images_grid.dart';
import 'package:customized_files_picker/global/widgets/shimmer_grid.dart';
import 'package:customized_files_picker/global/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

import '../../../global/methods_helpers_utils/media_query.dart';

class PickImageBottomSheet extends StatefulWidget {
  const PickImageBottomSheet({super.key});

  @override
  State<PickImageBottomSheet> createState() => _PickImageBottomSheetState();
}

class _PickImageBottomSheetState extends State<PickImageBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
                    tabs: <Widget>[Tab(text: 'Images'), Tab(text: 'Albums')],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  SizedBox(
                    height: MQuery.getheight(context, 500),
                    child: BlocBuilder<LocalImagesBloc, LocalImagesState>(
                      builder: (context, state) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            state is ErrorToFetchLocalImagesState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchLocalImagesState
                                ? ImagesGrid(images: state.images)
                                : ShimmerGrid(),

                            state is ErrorToFetchLocalImagesState
                                ? Center(child: Text(state.message))
                                : state is DoneToFetchLocalImagesState
                                ? ImageBucketsList(buckets: state.buckets, images: state.images)
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
