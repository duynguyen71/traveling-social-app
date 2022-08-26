import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../constants/api_constants.dart';
import 'my_outline_button.dart';

class FollowUserEntry extends StatefulWidget {
  const FollowUserEntry(
      {Key? key,
      this.username,
      this.avt,
      required this.isFollowing,
      required this.userService,
      required this.userId,
      this.followText = 'Follow'})
      : super(key: key);

  final String? username, avt;
  final bool isFollowing;
  final UserService userService;
  final int userId;
  final String followText;

  @override
  State<FollowUserEntry> createState() => _FollowUserEntryState();
}

class _FollowUserEntryState extends State<FollowUserEntry> {
  bool _isFollowing = false;

  @override
  void initState() {
    setState(() => _isFollowing = widget.isFollowing);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() => _isFollowing = widget.isFollowing);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, ProfileScreen.route(widget.userId)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          children: [
            UserAvatar(
              size: 40,
              avt: widget.avt,
              onTap: () => Navigator.push(
                context,
                ProfileScreen.route(widget.userId),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('${widget.username}')),
            MyOutlineButton(
                onClick: () async {
                  if (_isFollowing) {
                    await widget.userService.unFollow(userId: widget.userId);
                  } else {
                    await widget.userService.follow(userId: widget.userId);
                  }
                  setState(() => _isFollowing = !_isFollowing);
                },
                text: _isFollowing ? 'Following' : widget.followText,
                color: _isFollowing ? kPrimaryColor : null,
                textColor: _isFollowing ? Colors.white : null),
          ],
        ),
      ),
    );
  }
}
