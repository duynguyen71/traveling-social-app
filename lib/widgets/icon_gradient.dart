import 'package:flutter/material.dart';

class LinearGradiantMask extends StatelessWidget {
  const LinearGradiantMask({
    Key? key,
    required this.child,
    this.colors,
  }) : super(key: key);
  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.topRight,
        colors: colors != null
            ? colors!
            : [Colors.greenAccent.shade200, Colors.blueAccent.shade200],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
