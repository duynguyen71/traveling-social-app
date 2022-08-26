import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {Key? key,
      required this.radius,
      required this.child,
      required this.color})
      : super(key: key);

  final double radius;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: radius,
        width: radius,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
