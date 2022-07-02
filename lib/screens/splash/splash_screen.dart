import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return _shimmerGradient.createShader(bounds);
          },
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
