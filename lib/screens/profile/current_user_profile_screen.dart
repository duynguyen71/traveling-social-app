import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_state.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/explore/components/post_entry.dart';
import 'package:traveling_social_app/screens/explore/explore_screen.dart';
import 'package:traveling_social_app/screens/profile/components/follow_count.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';
import 'package:traveling_social_app/screens/profile/components/profile_cover_background.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import 'components/profile_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();

  static Route route() => MaterialPageRoute(builder: (_) => const CurrentUserProfileScreen());
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    var postViewModel = context.read<CurrentUserPostViewModel>();
    if (!postViewModel.isFetched) {
      postViewModel.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //APPBAR
          const ProfileAppbar(),
          const ProfileCoverBackground(),
          //CURRENT USER POSTS
          SliverToBoxAdapter(
            child: Consumer<CurrentUserPostViewModel>(
              builder: (context, value, child) {
                var posts = value.posts;
                return Column(
                  children: List.generate(
                    posts.length,
                    (index) {
                      var post = posts.elementAt(index);
                      return PostEntry(
                        post: post,
                        key: ValueKey(post.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
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
