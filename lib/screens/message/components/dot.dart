import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  const Dot({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      height: size,
      width: size,
    );
  }
}
