import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
   icon,
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
