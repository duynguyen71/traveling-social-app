import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/home/components/home_stories.dart';

import '../../view_model/post_view_model.dart';
import '../home/components/post_entry.dart';

class MyFeed extends StatefulWidget {
  const MyFeed({Key? key}) : super(key: key);

  @override
  State<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if (context.read<PostViewModel>().posts.isEmpty) {
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
          if (!context.read<PostViewModel>().isLoading) {
            context.read<PostViewModel>().fetchMorePosts();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: ()async {
        },
        child: CustomScrollView(
          slivers: [
            //STORIES
            const SliverToBoxAdapter(
              child: HomeStories(),
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
                        key: ValueKey(posts.elementAt(index).id),
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
