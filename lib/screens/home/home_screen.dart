import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_theme_constants.dart';
import '../../my_theme.dart';
import '../feed/my_feed.dart';
import '../review/review_post_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _scrollViewController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(
        vsync: this,
        length: 2,
        initialIndex: 0,
        animationDuration: Duration.zero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.black87),
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            title: const Text(
              'TC Social',
              style: TextStyle(
                color: kPrimaryColor,
                letterSpacing: 1,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.push(context, SearchScreen.route('')),
                icon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  color: Colors.black87,
                ),
              ),
            ],
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            // expandedHeight: 700,
            collapsedHeight: 56,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              //TAB BAR
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200))),
                child: TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: kPrimaryColor,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicatorWeight: 1.75,
                  labelStyle: MyTheme.heading2.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.myFeed),
                    Tab(text: AppLocalizations.of(context)!.review),
                  ],
                ),
              ),
            ),
            forceElevated: innerBoxIsScrolled,
          ),
        ];
      },
      body: Container(
        color: Colors.grey[100],
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            MyFeed(),
            ReviewPostScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
