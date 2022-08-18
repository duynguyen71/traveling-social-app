import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/bloc/locale/locale_cubit.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/repository/authentication_repository/authentication_repository.dart';
import 'package:traveling_social_app/repository/notification_repository/notification_repository.dart';
import 'package:traveling_social_app/repository/user_repository/user_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traveling_social_app/screens/explore/explore_screen.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/message/bloc/chat_bloc.dart';
import 'package:traveling_social_app/screens/splash/splash_screen.dart';
import 'authentication/bloc/authentication_state.dart';
import 'bloc/notification/notification_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//root application
class App extends StatelessWidget {
  const App(
      {Key? key,
      required this.userRepo,
      required this.authRepo,
      required this.notificationRepo})
      : super(key: key);

  final UserRepository userRepo;
  final AuthenticationRepository authRepo;
  final NotificationRepository notificationRepo;

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
          BlocProvider<NotificationBloc>(
              create: (context) =>
                  NotificationBloc(notificationRepository: notificationRepo),
              lazy: false),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
          ),
          BlocProvider<PostBloc>(
            create: (_) => PostBloc(),
          ),
          BlocProvider<StoryBloc>(
            create: (_) => StoryBloc(),
          ),
          BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
          BlocProvider<CreateReviewPostCubit>(
            create: (_) => CreateReviewPostCubit(),
            lazy: true,
          ),
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

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(builder: (_, localeState) {
      return MaterialApp(
        title: 'TC Social',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: localeState.locale,
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade100,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          // textTheme: GoogleFonts.robotoTextTheme(),
        ),
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
        // onGenerateRoute: (_) => Router,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print('AppLifecycleState.resumed');
          break;
        }
      case AppLifecycleState.inactive:
        {
          print('AppLifecycleState.inactive');
          break;
        }
      case AppLifecycleState.paused:
        {
          print('AppLifecycleState.paused');
          break;
        }
      case AppLifecycleState.detached:
        {
          print('AppLifecycleState.detached');
          break;
        }

      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    print('app view dispose');
    super.dispose();
  }
}
