import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/screens/home/components/drawer.dart';
import 'package:traveling_social_app/screens/home/components/home_body.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/profile/components/create_post_type_dialog.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/search/search_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';

import '../../widgets/user_avt.dart';
import 'components/post_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late UserViewModel _userViewModel;
  late User _user;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    ApplicationUtility.hideKeyboard();
    _userViewModel = context.read<UserViewModel>();
    if (_userViewModel.user == null) {
      ApplicationUtility.pushAndReplace(context, const LoginScreen());
    }
    _user = _userViewModel.user!;
    context.read<PostViewModel>().fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!context.read<PostViewModel>().isLoading) {
          context.read<PostViewModel>().fetchMorePosts();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: false,
      drawer: HomeDrawer(user: _user),
      body: Builder(
        builder: (context) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            //APP BAR
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 1),
                child: Divider(
                  color: kPrimaryColor.withOpacity(.2),
                  height: 1,
                ),
              ),
              backgroundColor: Colors.white,
              floating: true,
              leading: IconButton(
                focusColor: kPrimaryColor,
                hoverColor: kPrimaryColor,
                icon: SvgPicture.asset("assets/icons/menu.svg",
                    color: Colors.black),
                color: Colors.black,
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
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
                      size: 25,
                      avt: _user.avt.toString(),
                      onTap: () => ApplicationUtility.navigateToScreen(
                          context, const CurrentUserProfileScreen()),
                    ),
                  ),
                ),
              ],
              // expandedHeight: 250,
            ),
            //  END OF APP BAR
            const SliverToBoxAdapter(
              child: HomeBody(),
            ),
            //HOME POST
            Consumer<PostViewModel>(
              builder: (context, value, child) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var posts = value.posts;
                    if (index == posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return PostEntry(
                      post: posts.elementAt(index),
                      key: ValueKey(posts.elementAt(index).id),
                    );
                  },
                  childCount: value.posts.length + 1,
                  addAutomaticKeepAlives: true,
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text(
      //         'Home',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.card_giftcard),
      //       title: Text(
      //         'Deals',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       title: Text(
      //         'Favourites',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.portrait),
      //       title: Text(
      //         'Profile',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
