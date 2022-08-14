import 'package:flutter/material.dart';

class CoverImageContainer extends StatelessWidget {
  const CoverImageContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        height: 180,
        constraints: const BoxConstraints(minHeight: 180),
        width: double.infinity,
        child: child,
      ),
    );
  }
}
