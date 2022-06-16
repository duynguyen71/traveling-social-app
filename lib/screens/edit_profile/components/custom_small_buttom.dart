import 'package:flutter/material.dart';

class CustomSmallTextButton extends StatelessWidget {
  const CustomSmallTextButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 8,
        ),
      ),
    );
  }
}
