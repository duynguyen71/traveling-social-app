import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  const IconWithText({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.black87,
          size: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        )
      ],
    );
  }
}
