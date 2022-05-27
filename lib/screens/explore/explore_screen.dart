import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/models/ReviewPost.dart';
import 'package:traveling_social_app/screens/feed/my_feed.dart';
import 'package:traveling_social_app/screens/review/review_screen.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';

import '../../services/post_service.dart';
import '../../utilities/application_utility.dart';
import '../../widgets/user_avt.dart';
import '../home/components/drawer.dart';
import '../profile/components/create_post_type_dialog.dart';
import '../profile/current_user_profile_screen.dart';
import '../search/search_screen.dart';
import '../review/components/review_post.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  final _postService = PostService();
  final List<ReviewPost> _posts = [];

  late TabController _tabController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _scrollViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    getReviewPosts();
    _tabController = TabController(
        vsync: this,
        length: 4,
        initialIndex: 0,
        animationDuration: Duration.zero);
  }

  getReviewPosts() async {
    final resp = await _postService.getReviewPosts();
    setState(() {
      _posts.addAll(resp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeDrawer(user: context.read<UserViewModel>().user!),
      body: Builder(builder: (context) {
        return NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                leading: IconButton(
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    icon: const Icon(Icons.menu)),
                actions: [
                  IconButton(
                      onPressed: () => ApplicationUtility.showModelBottomDialog(
                          context, const CreatePostTypeDialog()),
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
                    child: Consumer<UserViewModel>(
                      builder: (context, value, child) => UserAvatar(
                        size: 20,
                        user: context.read<UserViewModel>().user,
                        onTap: () => ApplicationUtility.navigateToScreen(
                            context, const CurrentUserProfileScreen()),
                      ),
                    ),
                  ),
                ],
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                //
                // pinned: true,

                // title: Text("Title"),
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
                      color: Colors.green,
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
                      Tab(
                        text: 'Popular',
                      ),
                      Tab(
                        text: 'W',
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
              // physics:const NeverScrollableScrollPhysics(),
              physics: NeverScrollableScrollPhysics(),
              children: [
                const MyFeed(),
                const ReviewScreen(),
                Container(
                  child: Text("data"),
                ),
                Container(
                  child: Text("data"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }
}

class TopDestination extends StatelessWidget {
  const TopDestination({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(8),
      width: size.width * .5,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: size.width * .2,
            height: size.width * .2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.pexels.com/photos/2325446/pexels-photo-2325446.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Text("data",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  )),
              Text("data", style: TextStyle(color: Colors.black54)),
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 12,
                    color: Colors.red,
                  ),
                  Text("4.5"),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
