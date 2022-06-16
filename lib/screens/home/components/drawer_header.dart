import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/user.dart';

class DrawerHeaderUserCard extends StatelessWidget {
  const DrawerHeaderUserCard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          // UserAvatar(size: 50, user: user,onTap: (){})
          const SizedBox(
            height: 6,
          ),
          Text(
            user.username.toString(),
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
