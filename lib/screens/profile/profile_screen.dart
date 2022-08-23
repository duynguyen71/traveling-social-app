import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/group.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/services/chat_service.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/widgets/my_outline_button.dart';

import '../../constants/app_theme_constants.dart';
import '../../services/user_service.dart';
import '../message/chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/post_list.dart';
import 'components/profile_header.dart';
import 'components/profile_tab_bar.dart';
import 'components/user_file_upload_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Route route(int userId) =>
      MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId));
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _postService = PostService();
  User? _user;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() async {
    User? user = await _userService.getUserDetail(userId: widget.userId);
    setState(() {
      _user = user;
    });
  }

  get isFollowing => _user != null ? _user!.isFollowing : false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([
                ProfileHeader(
                  username: _user?.username,
                  fullName: _user?.fullName,
                  website: _user?.website,
                  bio: _user?.bio,
                  avt: _user?.avt,
                  bgImage: _user?.background,
                  followerCount: _user?.followerCounts ?? 0,
                  followingCount: _user?.followingCounts ?? 0,
                  joinedDate: _user?.createDate,
                  onTapAvt: () {},
                  onTapBg: () {},
                  buttons: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: MyOutlineButton(
                          onClick: () async {
                            if (isFollowing) {
                              bool success = await _userService.unFollow(
                                  userId: widget.userId);
                              if (success) {
                                setState(() {
                                  _user!.isFollowing = false;
                                });
                              }
                            } else {
                              bool success = await _userService.follow(
                                  userId: widget.userId);
                              if (success) {
                                setState(() {
                                  _user!.isFollowing = true;
                                });
                              }
                            }
                          },
                          text: isFollowing
                              ? AppLocalizations.of(context)!.following
                              : AppLocalizations.of(context)!.follow,
                          color: isFollowing ? kPrimaryColor : null,
                          textColor: isFollowing ? Colors.white : null,
                          minWidth: 80,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 70,
                        child: MyOutlineButton(
                          onClick: () async {
                            var chatService = ChatService();
                            Group? chatGroup = await chatService
                                .getChatGroupBetweenTwoUsers(widget.userId);
                            if (chatGroup != null) {
                              Navigator.push(
                                  context,
                                  ChatScreen.route(
                                      groupId: chatGroup.id!,
                                      name: _user!.username));
                            }
                          },
                          text: 'Message',
                          minWidth: 70,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ]))
            ];
          },
          body: Column(
            children: [
              const ProfileTabBar(),
              Expanded(
                  child: TabBarView(
                children: [
                  PostList(
                    fetchPosts: (int? page, int? pageSize) async {
                      return _postService.getUserPosts(
                          userId: widget.userId,
                          page: page,
                          pageSize: pageSize);
                    },
                  ),
                  UserFileUploadGrid(userId: widget.userId),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
