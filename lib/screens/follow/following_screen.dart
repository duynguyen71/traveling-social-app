import 'package:flutter/material.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/widgets/base_app_bar.dart';
import 'package:traveling_social_app/widgets/follow_user_entry.dart';

import '../../models/base_user.dart';
import '../../widgets/scroll_end_notification.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();

  static Route route() => MaterialPageRoute(
        builder: (context) => const FollowingScreen(),
      );
}

class _FollowingScreenState extends State<FollowingScreen> {
  final _userService = UserService();
  final List<BaseUserInfo> _users = [];

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  _getUsers() {
    setState(() {
      _isLoading = true;
    });
    _userService.getFollowing(page: _page, pageSize: 30).then((value) {
      if (value.isEmpty) {
        setState(() {
          _hasReachMax = true;
        });
      } else {
        setState(() {
          _users.addAll(value);
          _isLoading = false;
          _page += 1;
        });
      }
    });
  }

  int _page = 0;
  bool _hasReachMax = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Đang theo dõi'),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [],
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: MyScrollEndNotification(
            onEndNotification: (no) {
              if (_isLoading || _hasReachMax) {
                return false;
              }
              _getUsers();
              return true;
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var user = _users[index];
                assert(user.id != null);
                return FollowUserEntry(
                  key: ValueKey(user.id),
                  userId: user.id!,
                  isFollowing: true,
                  username: user.username,
                  avt: user.avt,
                  userService: _userService,
                );
              },
              itemCount: _users.length,
            ),
          ),
        ),
      ),
    );
  }
}
