import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserViewModel _userViewModel;

  @override
  void initState() {
    _userViewModel = context.read<UserViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Home Screen'),
              TextButton(
                  onPressed: () {
                    ApplicationUtility.navigateToScreen(
                        context, const LoginScreen());
                    _userViewModel.signOut();
                  },
                  child: const Text('Sign out'))
            ],
          ),
        ),
      ),
    );
  }
}
