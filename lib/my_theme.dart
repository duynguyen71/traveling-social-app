import 'package:flutter/material.dart';

class MyTheme {
  static const TextStyle heading2 = TextStyle(
    // color: Colors.black87,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle bodyText1 = TextStyle(
    color: Colors.black54,
    fontSize: 14,
  );

  static const TextStyle bodyTextMessage =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w600);

  static const TextStyle bodyTextTime = TextStyle(
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
