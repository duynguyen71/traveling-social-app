import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/message/components/jumping_dots.dart';

import '../constants/app_theme_constants.dart';

class ChatScreenAppBar extends StatelessWidget with PreferredSizeWidget {
  const ChatScreenAppBar(
      {Key? key, required this.groupName, required this.isTyping})
      : super(key: key);
  final String groupName;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kChatAppBarHeight,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            groupName,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
            ),
          ),
          Visibility(
              child: const JumpingDots(numberOfDots: 3, dotSize: 6),
              visible: isTyping),
        ],
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call),
          color: kPrimaryColor,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.video_call),
          color: kPrimaryColor,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline),
          color: kPrimaryColor,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
