import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_theme_constants.dart';

class BaseSliverAppBar extends StatelessWidget {
  const BaseSliverAppBar(
      {Key? key,
      required this.title,
      this.actions = const [],
      this.bottom,
      this.flexibleSpace,
      this.forceElevated = false,
      this.elevation,
      this.height = kToolbarHeight})
      : super(key: key);

  final String title;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final bool forceElevated;
  final double? elevation;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: height,
      title: Text(
        title,
        style: kDefaultAppBarTextTitleStyle,
      ),
      pinned: true,
      automaticallyImplyLeading: false,
      elevation: elevation,
      centerTitle: false,
      backgroundColor: Colors.white,
      bottom: bottom,
      actions: actions,
      // elevation: 0,
    );
  }
}
