import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/Base_review_post_response.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../../widgets/user_avt.dart';
import 'components/base_review_post_widget.dart';

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
    List<BaseReviewPostResponse> rs = await postService.getReviewPosts();
    setState(() {
      _posts = rs;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await getReviewPosts();
      },
      child: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                constraints: const BoxConstraints(
                  minHeight: 40,
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _users
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BaseReviewPostWidget(reviewPost: _posts[index]);
                    },
                    itemCount: _posts.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
