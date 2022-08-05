import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/screens/account/account_screen.dart';
import 'package:traveling_social_app/screens/bookmark/bookmark_screen.dart';

import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/notification/notification_screen.dart';

import 'components/drawer.dart';
import 'components/main_bottom_nav.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const ExploreScreen());
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPageIndex = 0;

  //set page index and jump to page
  set currentPageIndex(int i) {
    setState(() => _currentPageIndex = i);
    _animateToPage(i);
  }

  setCurrentPageIndex(int i) => currentPageIndex = i;

  _animateToPage(int pageIndex) async {
    _pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then(
      (token) {
        print('device notification token\n$token\n');
      },
    );
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: Builder(builder: (context) => const HomeDrawer()),
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
          bottomNavigationBar: MainBottomNav(
              currentPageIndex: _currentPageIndex,
              setCurrentPageIndex: setCurrentPageIndex)),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
