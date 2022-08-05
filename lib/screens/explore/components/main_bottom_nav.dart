import 'package:flutter/material.dart';

import '../../../widgets/icon_gradient.dart';
import '../../home/components/badge_bottom_nav_item.dart';
import '../../profile/components/create_post_type_dialog.dart';
import 'my_bottom_nav_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav(
      {Key? key,
      required this.currentPageIndex,
      required this.setCurrentPageIndex})
      : super(key: key);

  final int currentPageIndex;
  final Function setCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      // margin: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.center,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: MyBottomNavItem(
                  iconData: Icons.home,
                  label: AppLocalizations.of(context)!.home,
                  onClick: () => setCurrentPageIndex(0),
                  isSelected: currentPageIndex == 0),
            ),
            Expanded(
              child: MyBottomNavItem(
                  iconData: Icons.bookmark,
                  label: AppLocalizations.of(context)!.bookmark,
                  onClick: () => setCurrentPageIndex(1),
                  isSelected: currentPageIndex == 1),
            ),
            Expanded(
              child: Center(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => const CreatePostTypeDialog(),
                          backgroundColor: Colors.transparent);
                    },
                    child: Ink(
                      child: LinearGradiantMask(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(200)),
                          width: 45,
                          height: 45,
                          child: const LinearGradiantMask(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BadgeBottomNavItem(
                  iconData: Icons.notifications,
                  label: AppLocalizations.of(context)!.notification,
                  onClick: () => setCurrentPageIndex(2),
                  isSelected: currentPageIndex == 2),
            ),
            Expanded(
              child: MyBottomNavItem(
                  iconData: Icons.person,
                  label: AppLocalizations.of(context)!.account,
                  onClick: () => setCurrentPageIndex(3),
                  isSelected: currentPageIndex == 3),
            ),
          ],
        ),
      ),
    );
  }
}