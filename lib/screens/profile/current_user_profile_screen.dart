import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/explore/explore_screen.dart';
import 'package:traveling_social_app/screens/profile/components/profile_cover_background.dart';
import 'components/profile_app_bar.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();

  static Route route() => MaterialPageRoute(builder: (_) => const CurrentUserProfileScreen());
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CustomScrollView(
        slivers: [
          //APPBAR
          ProfileAppbar(),
          ProfileCoverBackground(),
          //CURRENT USER POSTS
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
                return const ExploreScreen();
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
    );
  }

}
