import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/User.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key, required this.size, required this.user, this.onTap})
      : super(key: key);

  final double size;
  final User user;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size),
            border: Border.all(color: Colors.black12)),
        child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: FittedBox(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              child: user.avt != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl + user.avt!,
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
    // return SizedBox(
    //   height: 30,
    //   width: 30,
    //   child: CircleAvatar(
    //     backgroundColor: Colors.white,
    //     backgroundImage: user.avt != null
    //         ? CachedNetworkImageProvider(imageUrl + user.avt!)
    //         : Image.asset(
    //             'assets/images/blank-profile-picture.png',
    //             height: size,
    //             width: size,
    //             fit: BoxFit.cover,
    //           ) as ImageProvider,
    //   ),
    // );
  }
}
