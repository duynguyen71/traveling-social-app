import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/User.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key,
      required this.size,
       this.user,
      this.onTap,
      this.margin})
      : super(key: key);

  final double size;
  final User? user;
  final Function? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        margin: margin ?? const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size),
        ),
        child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: FittedBox(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              child: user?.avt != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl + user!.avt.toString(),
                      height: size,
                      width: size,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/blank-profile-picture.png',
                      height: size,
                      width: size,
                      fit: BoxFit.cover,
                    )),
        ),
      ),
    );
  }
}
