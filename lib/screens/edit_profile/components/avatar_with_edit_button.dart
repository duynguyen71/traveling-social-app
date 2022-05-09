import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class AvatarWithEditButton extends StatelessWidget {
  const AvatarWithEditButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: kPrimaryColor.withOpacity(.5),
              ),
              borderRadius: BorderRadius.circular(400),
            ),
            height: 145,
            width: 145,
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://images.pexels.com/photos/11780519/pexels-photo-11780519.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => this.onPressed(),
              icon: Icon(Icons.edit),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
