import 'package:flutter/material.dart';
class FollowCount extends StatelessWidget {
  const FollowCount({Key? key, required this.title, required this.count}) : super(key: key);
final String title;
final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
      count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
         Text(
          ' $title\t\t',
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
