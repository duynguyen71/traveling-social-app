import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.size,
    required this.avt,
    required this.onTap,
    this.isActive, this.padding,
  }) : super(key: key);

  final double size;
  final String? avt;
  final Function onTap;
  final bool? isActive;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding:padding,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                  color: Colors.white),
              constraints: BoxConstraints(minWidth: size, minHeight: size),
              child: CachedNetworkImage(
                imageUrl: '$imageUrl$avt',
                memCacheHeight: int.tryParse('$size'),
                memCacheWidth: int.tryParse('$size'),
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
                errorWidget: (context, url, error) => Container(
                  height: size,
                  width: size,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/blank-profile-picture.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: isActive != null && isActive == true
                      ? Colors.lightGreenAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              width: 10,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}
