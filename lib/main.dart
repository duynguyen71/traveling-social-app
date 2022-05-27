import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/explore/explore_screen.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/services/navigation_service.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/view_model/story_viewmodel.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(),
        ),
        ChangeNotifierProvider<StoryViewModel>(create: (_) => StoryViewModel()),
        ChangeNotifierProvider<PostViewModel>(create: (_) => PostViewModel()),
        ChangeNotifierProvider<CurrentUserPostViewModel>(create: (_) => CurrentUserPostViewModel()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'TV Social',
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = context.read<UserViewModel>();
    return FutureBuilder(
      future: _userViewModel.fetchUserDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData ? const ExploreScreen() : const LoginScreen();
        }
        return const Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
