import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/screens/explore/components/post_entry.dart';

import '../../../bloc/post/post_bloc.dart';

class HomePosts extends StatelessWidget {
  const HomePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        var posts = state.posts;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == posts.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: state.status == PostStateStatus.fetching
                      ? const Center(child: CupertinoActivityIndicator())
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
    );
  }
}