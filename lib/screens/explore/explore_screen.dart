import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/feed/my_feed.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/review/review_screen.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';

import '../../utilities/application_utility.dart';
import '../home/components/drawer.dart';
import '../profile/components/create_post_type_dialog.dart';
import '../profile/current_user_profile_screen.dart';
import '../search/search_screen.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
        key: _scaffoldKey,
        drawer: const HomeDrawer(),
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                leading: IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                actions: [
                  IconButton(
                    onPressed: () => ApplicationUtility.navigateToScreen(
                      context,
                      const ChatGroupsScreen(),
                    ),
                    icon: const Icon(
                        IconData(0xe5c9, fontFamily: 'MaterialIcons'),
                        color: Colors.black45),
                  ),
                  IconButton(
                      onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const CreatePostTypeDialog();
                            },
                            backgroundColor: Colors.transparent,
                          ),
                      icon: const Icon(Icons.edit, color: Colors.black45)),
                  IconButton(
                    onPressed: () => ApplicationUtility.navigateToScreen(
                        context, const SearchScreen(keyword: '')),
                    icon: SvgPicture.asset(
                      "assets/icons/search.svg",
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: CurrentUserAvt(
                      size: 20,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const CurrentUserProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: TabBar(
                    isScrollable: false,
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: kPrimaryLightColor.withOpacity(.8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(
                        text: 'My Feed',
                      ),
                      Tab(
                        text: 'Review',
                      ),
                    ],
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
                ReviewScreen(),
              ],
            ),
          ),
        ));
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
