import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/screens/explore/components/post_entry.dart';

import '../../../bloc/post/post_bloc.dart';
import '../../comment/comment_screen.dart';
import '../../profile/profile_screen.dart';

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
              var post = posts.elementAt(index);
              return PostEntry(
                post: post,
                key: ValueKey(post.id),
                onTapMoreIcon: () {
                  post.user?.id ==
                          context.read<AuthenticationBloc>().state.user.id
                      ? _showCurrentCuperinoModal(context, post)
                      : _showGuestModal(context, post);
                },
              );
            },
            addAutomaticKeepAlives: true,
            childCount: posts.length + 1,
          ),
        );
      },
    );
  }

  void _showCurrentCuperinoModal(BuildContext context, Post post) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Bạn có chắc muốn xóa bài viết này?'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Xóa'),
                          onPressed: () {
                            context.read<PostBloc>().add(RemovePost(post.id!));
                            Navigator.pop(context);
                          },
                          isDestructiveAction: true,
                        ),
                        CupertinoDialogAction(
                          child: const Text('Hủy'),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop("Hủy");
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Xóa'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showComment(context, post);
              },
              child: const Text('Bình luận'),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  void _showGuestModal(BuildContext context, Post post) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, ProfileScreen.route(post.user!.id!));
                },
                child: const Text('Xem trang cá nhân')),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showComment(context, post);
              },
              child: const Text('Bình luận'),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  void _showComment(BuildContext context, Post post) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CommentScreen(
            postId: post.id!,
            myComments: post.myComments,
          );
        },
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true);
  }
}
