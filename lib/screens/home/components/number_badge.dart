import 'package:flutter/material.dart';

class NumberBadge extends StatelessWidget {
  const NumberBadge({Key? key, required this.number}) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
