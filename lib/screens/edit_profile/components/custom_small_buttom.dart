import 'package:flutter/cupertino.dart';
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
      onPressed: () => this.onPressed(),
      child: Text(
        this.text,
        style: TextStyle(color: this.textColor),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: this.backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 8,
        ),
      ),
    );
  }
}
