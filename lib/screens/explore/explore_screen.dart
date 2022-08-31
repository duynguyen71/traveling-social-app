import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/account/account_screen.dart';
import 'package:traveling_social_app/screens/bookmark/bookmark_screen.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/notification/notification_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';

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

  setCurrentPageIndex(int i) {
    setState(() {
      _pageController.jumpToPage(i);
      _currentPageIndex = i;
    });
  }

  @override
  void initState() {
    super.initState();
    var firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.onTokenRefresh.listen((token) {
      UserService().updateToken(token);
    });
    _pageController =
        PageController(initialPage: _currentPageIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        _pageController.jumpToPage(0);
        setState(() {
          _currentPageIndex = 0;
        });
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
