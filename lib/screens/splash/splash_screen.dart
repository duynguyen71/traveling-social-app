import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/widgets/config_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (context) => const SplashScreen());

  final LinearGradient _shimmerGradient = const LinearGradient(
    colors: [
      // Color(0xFFEBEBF4),
      Colors.redAccent,
      Colors.blue, Colors.orange
    ],
    // stops: [
    //   0.1,
    //   0.3,
    //   0.4,
    // ],
    // begin: Alignment(-1.0, -0.3),
    // end: Alignment(1.0, 0.3),
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
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return _shimmerGradient.createShader(bounds);
              },
              child: const CupertinoActivityIndicator(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ConfigWidget(
                  onTap: () => Navigator.pushAndRemoveUntil<void>(
                        context,
                        LoginScreen.route(),
                        (route) => false,
                      )),
            )
          ],
        ),
      ),
    );
  }
}
