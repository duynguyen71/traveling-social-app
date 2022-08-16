import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/explore/components/home_posts.dart';
import 'package:traveling_social_app/screens/feed/components/feed_action_button.dart';
import 'package:traveling_social_app/screens/explore/components/home_stories.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/profile/components/create_post_type_dialog.dart';
import 'package:traveling_social_app/screens/setting/setting_screen.dart';

import '../explore/components/post_entry.dart';

class MyFeed extends StatefulWidget {
  const MyFeed({Key? key}) : super(key: key);

  @override
  State<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const FetchPost());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoryBloc>().add(const FetchStory(isRefreshing: true));
        context.read<PostBloc>().add(const FetchPost(isRefreshing: true));
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          var position = scrollNotification.metrics;
          if (position.pixels == position.maxScrollExtent) {
            context.read<PostBloc>().add(const FetchPost());
            return true;
          }
          return false;
        },
        child: const CustomScrollView(
          shrinkWrap: true,
          slivers: [
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
