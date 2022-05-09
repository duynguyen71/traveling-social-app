import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/User.dart';
import 'package:traveling_social_app/screens/create_post/create_post_screen.dart';
import 'package:traveling_social_app/screens/create_story/create_story_screen.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/profile/components/background.dart';
import 'package:traveling_social_app/screens/profile/components/follow_count.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'components/button_edit_profile.dart';
import 'components/profile_app_bar.dart';
import 'components/title_with_number.dart';
import 'package:provider/provider.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {
  bool _isLoading = false;


  late UserViewModel _userViewModel;

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //APPBAR
            ProfileAppbar(),
            //BODY
            SliverToBoxAdapter(
              child: CurrentUserProfileBackground(
                isLoading: _isLoading,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          //AVT
                          const ProfileAvtAndCover(),
                          //STORIES
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //FULL NAME
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Selector<UserViewModel, String>(
                                      builder: (BuildContext context, value,
                                              Widget? child) =>
                                          const Text(
                                        'Nguyen Khanh Duy',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      selector: (p0, p1) =>
                                          p1.user!.username.toString(),
                                    ),
                                  ),
                                  //USERNAME
                                  Selector<UserViewModel, String>(
                                    builder: (BuildContext context, value,
                                            Widget? child) =>
                                        Text(
                                      '@$value',
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 15),
                                    ),
                                    selector: (p0, p1) =>
                                        p1.user!.username.toString(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Selector<UserViewModel, int?>(
                                          builder: (BuildContext context, value,
                                                  Widget? child) =>
                                              FollowCount(
                                                  title: "Following",
                                                  count: value.toString()),
                                          selector: (p0, p1) =>
                                              p1.user!.followingCounts,
                                        ),
                                        Selector<UserViewModel, int?>(
                                          builder: (BuildContext context, value,
                                                  Widget? child) =>
                                              FollowCount(
                                                  title: "Follower",
                                                  count: value.toString()),
                                          selector: (p0, p1) =>
                                              p1.user!.followerCounts,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Divider(indent: 1, thickness: 1),
                                    width: size.width * .7,
                                  ),
                                  const Text(
                                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),

                                  //
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: kPrimaryColor,
          ),
          child: IconButton(
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const HomeScreen();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            ),
            icon: const Icon(Icons.chat, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
