import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/screens/explore/components/home_posts.dart';
import 'package:traveling_social_app/screens/explore/components/home_stories.dart';

class MyFeed extends StatefulWidget {
  const MyFeed({Key? key}) : super(key: key);

  @override
  State<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const FetchPost());
      _scrollController.addListener(() {
        var position = _scrollController.position;
        if (position.pixels == position.maxScrollExtent) {
          context.read<PostBloc>().add(const FetchPost());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoryBloc>().add(const FetchStory(isRefreshing: true));
        context.read<PostBloc>().add(const FetchPost(isRefreshing: true));
      },
      child: CustomScrollView(
        controller: _scrollController,
        shrinkWrap: true,
        slivers: const [
          //STORIES
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          HomeStories(),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          HomePosts(),
          // BUILDER FOR POSTS STATE
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
