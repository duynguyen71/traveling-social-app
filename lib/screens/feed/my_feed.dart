import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
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
      onRefresh: () async {},
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          var position = scrollNotification.metrics;
          if (position.pixels == position.maxScrollExtent) {
            context.read<PostBloc>().add(const FetchPost());
            return true;
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            //STORIES
            const SliverToBoxAdapter(
              child: HomeStories(),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [kDefaultShadow],
                    borderRadius: BorderRadius.circular(50.0)),
                margin: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    FeedActionButton(
                        onClick: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => const CreatePostTypeDialog(),
                              backgroundColor: Colors.transparent);
                        },
                        asset: 'assets/icons/add.svg'),
                    FeedActionButton(
                        onClick: () =>
                            Navigator.push(context, ChatGroupsScreen.route()),
                        asset: 'assets/icons/message.svg'),
                    const Spacer(),
                    FeedActionButton(
                        onClick: () =>
                            Navigator.push(context, SettingScreen.route()),
                        asset: 'assets/icons/setting.svg'),
                  ],
                ),
              ),
            ),
            // BUILDER FOR POSTS STATE
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                print('build posts');
                var posts = state.posts;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == posts.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: state.status == PostStateStatus.fetching
                              ? const Center(
                                  child: CupertinoActivityIndicator())
                              : const SizedBox.shrink(),
                        );
                      }
                      return PostEntry(
                        post: posts.elementAt(index),
                        key: ValueKey(posts.elementAt(index).id),
                      );
                    },
                    childCount: posts.length + 1,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
