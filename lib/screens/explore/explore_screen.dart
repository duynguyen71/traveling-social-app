import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/account/account_screen.dart';
import 'package:traveling_social_app/screens/bookmark/bookmark_screen.dart';
import 'package:traveling_social_app/screens/explore/components/my_bottom_nav_item.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/notification/notification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/drawer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const ExploreScreen());
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late PageController _pageController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // final _scrollViewController = ScrollController();

  int _currentPageIndex = 0;

  //set page index and jump to page
  set currentPageIndex(int i) {
    setState(() => _currentPageIndex = i);
    _animateToPage(i);
  }

  _animateToPage(int pageIndex) async {
    _pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  @override
  void initState() {
    // _tabController = TabController(
    //     vsync: this,
    //     length: 2,
    //     initialIndex: 0,
    //     animationDuration: Duration.zero);
    FirebaseMessaging.instance.getToken().then(
      (token) {
        print('device notification token\n$token\n');
      },
    );
    // AppLocalizations.of(context).
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: const HomeDrawer(),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            BookmarkScreen(),
            NotificationScreen(),
            AccountScreen()
          ],
        ),
        bottomNavigationBar: Container(
          height: 60.0,
          padding: const EdgeInsets.only(bottom: 8.0),
          alignment: Alignment.center,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyBottomNavItem(
                      iconData: Icons.home,
                      label: AppLocalizations.of(context)!.home,
                      onClick: () {
                        currentPageIndex = 0;
                      },
                      isSelected: _currentPageIndex == 0),
                ),
                Expanded(
                  child: MyBottomNavItem(
                      iconData: Icons.bookmark,
                      label:  AppLocalizations.of(context)!.bookmark,
                      onClick: () {
                        currentPageIndex = 1;
                      },
                      isSelected: _currentPageIndex == 1),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor.withOpacity(.7),
                          borderRadius: BorderRadius.circular(200)),
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset(
                        'assets/icons/add.svg',
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: MyBottomNavItem(
                      iconData: Icons.notifications,
                      label:  AppLocalizations.of(context)!.notification,
                      onClick: () {
                        currentPageIndex = 2;
                      },
                      isSelected: _currentPageIndex == 2),
                ),
                Expanded(
                  child: MyBottomNavItem(
                      iconData: Icons.person,
                      label:  AppLocalizations.of(context)!.account,
                      onClick: () {
                        currentPageIndex = 4;
                      },
                      isSelected: _currentPageIndex == 3),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // _tabController.dispose();
    // _scrollViewController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
