import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: FittedBox(
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            'https://images.pexels.com/photos/11185227/pexels-photo-11185227.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            height: size,
            width: size,
            fit: BoxFit.cover,
          )

          ),
    );
  }
}
