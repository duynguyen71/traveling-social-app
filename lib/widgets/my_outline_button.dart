import 'package:flutter/material.dart';

import '../constants/app_theme_constants.dart';

class MyOutlineButton extends StatelessWidget {
  const MyOutlineButton(
      {Key? key,
      required this.onClick,
      required this.text,
      this.textColor,
      this.color,
      this.borderColor,
      this.height = 30,
      this.minWidth = 100})
      : super(key: key);

  final Function onClick;
  final String text;
  final Color? textColor, color, borderColor;
  final double height;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            style: BorderStyle.solid,
            color: borderColor ?? kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(40),
          color: color ?? Colors.transparent),
      child: TextButton(
        onPressed: () {
          onClick();
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: textColor ?? kPrimaryColor,
              letterSpacing: .6,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(100, 30),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
