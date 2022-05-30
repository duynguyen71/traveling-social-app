import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/User.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key,
      required this.size,
      required this.user,
     required this.onTap,
      this.margin})
      : super(key: key);

  final double size;
  final User user;
  final Function onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: margin ?? const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl + user.avt.toString(),
          imageBuilder: (context, imageProvider) => Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // placeholder: (context, url) => placeholder,
          // errorWidget: (context, url, error) => errorWidget,
        ),
      ),
    );
  }
}
