import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/ReviewPost.dart';

import '../../models/Post.dart';
import '../../services/post_service.dart';
import 'components/review_post.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with AutomaticKeepAliveClientMixin {
  final postService = PostService();
  final List<ReviewPost> _posts = [];

  @override
  void initState() {
    super.initState();
    print("REVIEW SCREEN INIT");

    getReviewPosts();
  }

  getReviewPosts() async {
    List<ReviewPost> rs = await postService.getReviewPosts();
    setState(() {
      _posts.addAll(rs);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(_posts.length, (index) {
                        ReviewPost reviewPost = _posts[index];
                        return ReviewPlace(reviewPost: reviewPost);
                      }),
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

  @override
  bool get wantKeepAlive => true;
}
