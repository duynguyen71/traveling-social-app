import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({Key? key, required this.text, required this.icon, this.onTap})
      : super(key: key);

  final String text;
  final Icon icon;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
      ),
    );
  }
}
