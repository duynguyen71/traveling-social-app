import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  const BaseAppBar({Key? key, required this.title, this.leading, this.actions})
      : super(key: key);

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: actions,
      leading: leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black87,
            icon: const Icon(Icons.arrow_back_ios),
          ),
      title: Text(
        title,
        style: kDefaultAppBarTextTitleStyle,
      ),
      centerTitle: true,

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
