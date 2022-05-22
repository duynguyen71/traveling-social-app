import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/screens/home/components/post_entry.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/profile/components/follow_count.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'components/profile_app_bar.dart';
import 'package:provider/provider.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  _getPosts() async {
    final posts =
        await _postService.getCurrentUserPosts(page: page, pageSize: 5);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //APPBAR
          const ProfileAppbar(),
          //BODY
          _buildCoverBackground(size),
          SliverToBoxAdapter(
            child: Column(
              children: List.generate(
                _posts.length,
                (index) {
                  var post = _posts[index];
                  return PostEntry(post: post, key: ValueKey(post.id));
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: kPrimaryColor,
        ),
        child: IconButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return const HomeScreen();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(0.0, 1.0);
                var end = Offset.zero;
                var tween = Tween(begin: begin, end: end);
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          ),
          icon: const Icon(Icons.chat, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCoverBackground(Size size) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //AVT
            const ProfileAvtAndCover(),
            //USER INFO
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Selector<UserViewModel, String>(
                        builder: (BuildContext context, value, Widget? child) =>
                            Text(
                          '@$value',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 18),
                        ),
                        selector: (p0, p1) => p1.user!.username.toString(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Selector<UserViewModel, int?>(
                          builder:
                              (BuildContext context, value, Widget? child) =>
                                  FollowCount(
                                      title: "Following",
                                      count: value.toString()),
                          selector: (p0, p1) => p1.user!.followingCounts,
                        ),
                        Selector<UserViewModel, int?>(
                          builder:
                              (BuildContext context, value, Widget? child) =>
                                  FollowCount(
                                      title: "Follower",
                                      count: value.toString()),
                          selector: (p0, p1) => p1.user!.followerCounts,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconWithText(
                                  text: "Ho Chi Minh city",
                                  icon: Icons.location_on_outlined),
                              SizedBox(width: 10),
                              IconWithText(
                                  text:
                                      'Joined date ${Jiffy(context.read<UserViewModel>().user!.createDate.toString()).format('dd-MM-yyyy')}',
                                  icon: Icons.calendar_today_outlined),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              IconWithText(
                                  text: "Ho Chi Minh city",
                                  icon: Icons.location_on_outlined),
                              SizedBox(width: 10),
                              IconWithText(
                                  text: "Ho Chi Minh city",
                                  icon: Icons.location_on_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //BIO
                    SizedBox(
                      child: const Divider(indent: 1, thickness: 1),
                      width: size.width * .7,
                    ),
                    Selector<UserViewModel, String?>(
                      selector: ((p0, p1) => p1.user!.bio.toString()),
                      builder: (context, value, child) => Text(
                        value.toString().trim(),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    //
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
