import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_theme_constants.dart';

class BaseSliverAppBar extends StatelessWidget {
  const BaseSliverAppBar({Key? key, required this.title, required this.actions})
      : super(key: key);

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: kDefaultAppBarTextTitleStyle,
      ),
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      // elevation: 0,
    );
  }
}
