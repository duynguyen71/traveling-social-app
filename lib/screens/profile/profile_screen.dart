import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/screens/home/components/post_entry.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/widgets/my_outline_button.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/post.dart';
import '../../services/user_service.dart';
import 'components/follow_count.dart';
import 'components/icon_with_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _postService = PostService();

  final Set<Post> _posts = <Post>{};
  User? _user;
  int _page = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserDetail();
    getUserPosts();
  }

  getUserDetail() async {
    isLoading = true;
    User? user = await _userService.getUserDetail(userId: widget.userId);
    setState(() {
      _user = user;
    });
    isLoading = false;
  }

  getUserPosts() async {
    isLoading = true;
    List<Post> posts = await _postService.getUserPosts(
        userId: widget.userId, page: _page, pageSize: 2);
    setState(() => _posts.addAll(posts));
    if (posts.isNotEmpty) {
      _page = _page + 1;
    } else if (_page >= 1) {
      _page = _page - 1;
    }
    isLoading = false;
  }

  set isLoading(bool i) => setState(() {
        _isLoading = i;
      });

  get isFollowed => _user != null ? _user!.isFollowed : false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              iconTheme: const IconThemeData(color: Colors.black87),
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              title: Text(
                _user != null ? _user!.username.toString() : '',
                style: const TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ],
            ),
          ];
        },
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (!_isLoading) {
              var position = notification.metrics;
              if (position.pixels == position.maxScrollExtent) {
                getUserPosts();
              }
              return true;
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //AVT
                      SizedBox(
                        height: size.height * .4,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Container(
                              height: (size.height * .4 - 80),
                              width: double.infinity,
                              color: Colors.grey.shade50,
                              child: GestureDetector(
                                onTap: () {},
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: _user != null
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: imageUrl +
                                              _user!.background.toString(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/images/home_bg.png",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),

                            //CURRENT USER AVT
                            _user != null
                                ? Positioned(
                                    bottom: 0,
                                    left: kDefaultPadding,
                                    child: UserAvatar(
                                      size: 150,
                                      onTap: () {},
                                      avt: _user!.avt.toString(),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Positioned(
                              bottom: 0,
                              right: kDefaultPadding / 2,
                              child: Container(
                                constraints:
                                    const BoxConstraints(minWidth: 130),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                height: 40,
                                child: MyOutlineButton(
                                    onClick: () async {
                                      if (isFollowed) {
                                        bool success = await _userService
                                            .unFollow(userId: widget.userId);
                                        if (success) {
                                          setState(() {
                                            _user!.isFollowed = false;
                                          });
                                        }
                                      } else {
                                        bool success = await _userService
                                            .follow(userId: widget.userId);
                                        if (success) {
                                          setState(() {
                                            _user!.isFollowed = true;
                                          });
                                        }
                                      }
                                    },
                                    text: isFollowed ? "Following" : "Follow",
                                    color: isFollowed ? kPrimaryColor : null,
                                    textColor:
                                        isFollowed ? Colors.white : null),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //  INFO
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  _user != null
                                      ? '@${_user!.username.toString()}'
                                      : '',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ),
                              _user != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FollowCount(
                                            title: "Following",
                                            count: _user!.followingCounts),
                                        FollowCount(
                                            title: "Follower",
                                            count: _user!.followerCounts),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const IconWithText(
                                            text: "Ho Chi Minh city",
                                            icon: Icons.location_on_outlined),
                                        const SizedBox(width: 10),
                                        IconWithText(
                                            text:
                                                'Joined date ${Jiffy(_user?.createDate).format('dd-MM-yyyy')}',
                                            icon:
                                                Icons.calendar_today_outlined),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                              Text(
                                _user != null ? _user!.bio ?? '' : '',
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                    children: List.generate(_posts.length, (index) {
                  var post = _posts.elementAt(index);
                  return PostEntry(
                    post: post,
                    key: ValueKey(post.id),
                  );
                })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
