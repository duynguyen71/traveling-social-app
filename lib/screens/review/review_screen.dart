import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/models/review_post.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../../widgets/user_avt.dart';
import 'components/review_post.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with AutomaticKeepAliveClientMixin {
  final postService = PostService();
  final _userService = UserService();
  final List<ReviewPost> _posts = [];
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
    getTopActiveUsers();
  }

  getTopActiveUsers() async {
    if (_users.isEmpty) {
      List<BaseUserInfo> users = await _userService.getTopActiveUsers();
      setState(() {
        _users = users;
      });
    }
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
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              constraints:const BoxConstraints(minHeight: 40,),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _users
                      .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: UserAvatar(
                            size: 40,
                            avt: e.avt.toString(),
                            onTap: () {
                              ApplicationUtility.navigateToScreen(
                                  context, ProfileScreen(userId: e.id!));
                            }),
                      ))
                      .toList(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
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
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
