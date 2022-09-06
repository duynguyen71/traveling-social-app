import 'package:flutter/material.dart';

class FollowCount extends StatelessWidget {
  const FollowCount({Key? key, required this.title, this.count = 0})
      : super(key: key);
  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 100),
          child: Text(
            ' $title\t\t',
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
