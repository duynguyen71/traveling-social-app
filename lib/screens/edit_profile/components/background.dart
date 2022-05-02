import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset("assets/images/top_left.png"),
          width: size.width * .45,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset("assets/images/bottom_left.png"),
          width: size.width * .3,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset("assets/images/bottom_right.png"),
          width: size.width * .35,
        ),
        this.child,
      ],
    );
  }
}
