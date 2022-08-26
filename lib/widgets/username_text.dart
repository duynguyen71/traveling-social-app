import 'package:flutter/material.dart';

class UsernameText extends StatelessWidget {
  const UsernameText({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}
