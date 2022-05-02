import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class HeadingWithIcon extends StatelessWidget {
  const HeadingWithIcon({Key? key, required this.icon, required this.title})
      : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: const Divider(
              height: 1,
              color: kPrimaryLightColor,
            ),
          ),
        )
      ],
    );
  }
}
