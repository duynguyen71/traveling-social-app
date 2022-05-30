import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/User.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

class DrawerHeaderUserCard extends StatelessWidget {
  const DrawerHeaderUserCard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          UserAvatar(size: 50, user: user,onTap: (){})
          // ClipOval(
          //   clipBehavior: Clip.hardEdge,
          //   child: Image.network(
          //     // this.imageUrl.isEmpty
          //     "https://images.pexels.com/photos/4429452/pexels-photo-4429452.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"
          //     // : this.imageUrl.toString(),
          //     ,
          //     fit: BoxFit.cover,
          //     width: 50,
          //     height: 50,
          //   ),
          // ),,
          ,
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
