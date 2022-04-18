import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      home: const LoginScreen(),
    );
  }
}
