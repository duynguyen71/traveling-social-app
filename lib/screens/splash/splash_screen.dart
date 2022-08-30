import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/widgets/config_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../authentication/bloc/authentication_event.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (context) => const SplashScreen());

  final LinearGradient _shimmerGradient = const LinearGradient(
    colors: [Colors.redAccent, Colors.blue, Colors.orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.mirror,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center(child: const CupertinoActivityIndicator(),),
            Center(
              child: Image.asset(
                'assets/icons/tc_launcher_icon.png',
                filterQuality: FilterQuality.high,
                height: 64,
                width: 64,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ConfigWidget(
                  onTap: () =>
                      context.read<AuthenticationBloc>().add(
                          AuthenticationLogoutRequested())),
            )
          ],
        ),
      ),
    );
  }
}
