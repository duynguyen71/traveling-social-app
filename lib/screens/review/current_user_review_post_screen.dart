import 'package:flutter/material.dart';

import '../../models/Base_review_post_response.dart';
import '../../services/post_service.dart';

class CurrentUserReviewPostScreen extends StatefulWidget {
  const CurrentUserReviewPostScreen({Key? key}) : super(key: key);

  @override
  State<CurrentUserReviewPostScreen> createState() =>
      _CurrentUserReviewPostScreenState();
  static Route route() => MaterialPageRoute(builder: (context) => const CurrentUserReviewPostScreen(),);
}

class _CurrentUserReviewPostScreenState
    extends State<CurrentUserReviewPostScreen> {

  final _postService = PostService();
  List<BaseReviewPostResponse> _posts = [];

  @override
  void initState() {
    _postService.getCurrentUserReviewPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
