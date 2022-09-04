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
      this.height = kToolbarHeight,
      this.isShowLeading = false, this.leading})
      : super(key: key);

  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final bool forceElevated;
  final double? elevation;
  final double height;
  final bool isShowLeading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: height,
      leading: leading,
      title: Text(
        title,
        style: kDefaultAppBarTextTitleStyle,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black54,
      ),
      iconTheme: IconThemeData(color: Colors.black54),
      pinned: true,
      automaticallyImplyLeading: isShowLeading,
      elevation: elevation,
      centerTitle: false,
      backgroundColor: Colors.white,
      bottom: bottom,
      actions: actions,
      // elevation: 0,
    );
  }
}
