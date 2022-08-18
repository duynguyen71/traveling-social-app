import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/Base_review_post_response.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/screens/review/components/review_post_entry.dart';
import 'package:traveling_social_app/screens/review/review_post_detail_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/rounded_image_container.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/user_avt.dart';
import 'components/post_meta.dart';
import 'components/review_post_card.dart';

class ReviewPostScreen extends StatefulWidget {
  const ReviewPostScreen({Key? key}) : super(key: key);

  @override
  State<ReviewPostScreen> createState() => _ReviewPostScreenState();
}

class _ReviewPostScreenState extends State<ReviewPostScreen>
    with AutomaticKeepAliveClientMixin {
  final postService = PostService();
  final _userService = UserService();
  List<BaseReviewPostResponse> _posts = [];
  List<BaseUserInfo> _users = [];
  bool _isLoading = false;

  set isLoading(bool i) {
    setState(() {
      _isLoading = i;
    });
  }

  @override
  void initState() {
    super.initState();
    getReviewPosts();
  }

  int _page = 0;
  bool _hasReachMax = false;

  getReviewPosts() async {
    if (_hasReachMax || _isLoading) return;
    isLoading = true;
    try {
      List<BaseReviewPostResponse> rs =
          await postService.getReviewPosts(page: _page, pageSize: 4);
      if (rs.isEmpty) {
        setState(() {
          _hasReachMax = true;
        });
      } else {
        setState(() {
          _posts.addAll(rs);
          _page = _page + 1;
        });
      }
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        List<BaseReviewPostResponse> rs =
            await postService.getReviewPosts(page: 0, pageSize: 4);
        setState(() {
          _posts = (rs);
          _page = 1;
          _hasReachMax = false;
        });
      },
      child: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                height: 150,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    var position = scrollNotification.metrics;
                    if (position.pixels == position.maxScrollExtent) {
                      getReviewPosts();
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == _posts.length) {
                          return _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              : const SizedBox.shrink();
                        }
                        return ReviewPostCard(reviewPost: _posts[index]);
                      },
                      itemCount: _posts.length + 1),
                ),
              ),
            ),
            // List random review post
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var post = _posts[index];
                      return ReviewPostEntry(
                        imageName: post.coverPhoto?.name,
                        title: post.title,
                        onTap: () => Navigator.push(
                            context, ReviewPostDetailScreen.route(post.id!)),
                        child: PostMetadata(
                            username: post.user?.username,
                            createDate: post.createDate),
                      );
                    },
                    itemCount: _posts.length,
                    shrinkWrap: true),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
