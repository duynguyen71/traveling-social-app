import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/repository/authentication_repository/authentication_repository.dart';
import 'package:traveling_social_app/repository/user_repository/user_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traveling_social_app/screens/explore/explore_screen.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/message/bloc/chat_bloc.dart';
import 'package:traveling_social_app/screens/splash/splash_screen.dart';
import 'package:traveling_social_app/services/navigation_service.dart';
import 'package:traveling_social_app/view_model/chat_room_view_model.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/view_model/story_view_model.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';

import 'authentication/bloc/authentication_state.dart';
import 'main.dart';

//root application
class App extends StatelessWidget {
  const App({Key? key, required this.userRepo, required this.authRepo})
      : super(key: key);

  final UserRepository userRepo;
  final AuthenticationRepository authRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => userRepo),
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => authRepo)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  authenticationRepository: authRepo,
                  userRepository: userRepo)),
          BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<UserViewModel>(
        //   create: (_) => UserViewModel(),
        // ),
        ChangeNotifierProvider<StoryViewModel>(create: (_) => StoryViewModel()),
        ChangeNotifierProvider<PostViewModel>(create: (_) => PostViewModel()),
        ChangeNotifierProvider<CurrentUserPostViewModel>(
            create: (_) => CurrentUserPostViewModel()),
        ChangeNotifierProvider<ChatRoomViewModel>(
            create: (_) => ChatRoomViewModel()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'TC Social',
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.robotoTextTheme(),
            // textTheme: GoogleFonts.robotoTextTheme(),
          ),
          // home: const AuthWrapper(),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      ExploreScreen.route(),
                      (route) => false,
                    );
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      LoginScreen.route(),
                      (route) => false,
                    );
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => SplashScreen.route(),
        );
      },
    );
  }
}
