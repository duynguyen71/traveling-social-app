import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/feed/components/feed_action_button.dart';
import 'package:traveling_social_app/screens/explore/components/home_stories.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/profile/components/create_post_type_dialog.dart';
import 'package:traveling_social_app/screens/setting/setting_screen.dart';

import '../../view_model/post_view_model.dart';
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
    if (context
        .read<PostViewModel>()
        .posts
        .isEmpty) {
      context.read<PostViewModel>().fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        var position = notification.metrics;
        if (position.pixels == position.maxScrollExtent) {
          if (!context
              .read<PostViewModel>()
              .isLoading) {
            context.read<PostViewModel>().fetchMorePosts();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            //STORIES
            const SliverToBoxAdapter(
              child: HomeStories(),
            ),
            //
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [kDefaultShadow],
                    borderRadius: BorderRadius.circular(50.0)),
                margin: const EdgeInsets.only(
                  bottom: 8.0,
                ),

                // padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FeedActionButton(
                        onClick: () {
                          showModalBottomSheet(context: context,
                              builder: (_) => const CreatePostTypeDialog(),
                              backgroundColor: Colors.transparent);
                        }, asset: 'assets/icons/add.svg'),
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
            //POSTS
            Consumer<PostViewModel>(
              builder: (context, value, child) {
                var posts = value.posts;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index == posts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return PostEntry(
                        post: posts.elementAt(index),
                        key: ValueKey(posts
                            .elementAt(index)
                            .id),
                      );
                    },
                    childCount: value.posts.length + 1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
