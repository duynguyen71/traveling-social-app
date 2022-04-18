import 'package:flutter/cupertino.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              "assets/images/bottom_right.png",
            ),
            bottom: 0,
            right: 0,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/top_left2.png",
                width: size.width * .3),
          ),
          child
        ],
      ),
    );
  }
}
