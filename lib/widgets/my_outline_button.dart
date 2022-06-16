import 'package:flutter/material.dart';

import '../constants/app_theme_constants.dart';

class MyOutlineButton extends StatelessWidget {
  const MyOutlineButton(
      {Key? key,
      required this.onClick,
      required this.text,
      this.textColor,
      this.color,
      this.borderColor})
      : super(key: key);

  final Function onClick;
  final String text;
  final Color? textColor, color, borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          style: BorderStyle.solid,
          color:borderColor?? kPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(40),
        color: color??Colors.transparent
        ),
      child: TextButton(
        onPressed: () {
          onClick();
        },
        child: Text(
          text,
          style: TextStyle(
            color: textColor??kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }
}
