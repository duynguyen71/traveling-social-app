import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.size,
    required this.avt,
    required this.onTap,
  }) : super(key: key);

  final double size;
  final String? avt;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            color: Colors.grey.shade50),
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        child:avt!=null? CachedNetworkImage(
          imageUrl: '$imageUrl$avt',
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
          errorWidget: (context, url, error) => Container(
            height: size,
            width: size,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              image: DecorationImage(
                image: AssetImage('assets/images/blank-profile-picture.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ): Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            image: DecorationImage(
              image: AssetImage('assets/images/blank-profile-picture.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
