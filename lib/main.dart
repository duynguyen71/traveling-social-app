import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/view_model/loading_viewmodel.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';
import 'package:traveling_social_app/widgets/overlay_loader.dart';

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
        ChangeNotifierProvider<PostViewModel>(create: (_) => PostViewModel()),
        ChangeNotifierProvider<LoadingViewModel>(
            create: (_) => LoadingViewModel())
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[100],
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),

          home: const AuthWrapper(),


          // home: const HomeScreen(),qs
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userViewModel = context.read<UserViewModel>();
    return FutureBuilder(
      future: _userViewModel.fetchUserDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData ? const HomeScreen() : const LoginScreen();
        }
        return const Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
