import 'package:flutter/material.dart';

import '../../../constants/app_theme_constants.dart';
import '../../../my_theme.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.white,
      child: TabBar(
        isScrollable: false,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: kPrimaryColor,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        labelStyle: MyTheme.heading2.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.grid_on_outlined),
          ),
          Tab(
            icon: Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
