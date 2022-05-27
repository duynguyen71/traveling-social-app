import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/User.dart';

class UserAvatar extends StatefulWidget {
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
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => widget.onTap != null ? widget.onTap!() : null,
      child: Container(
        margin: widget.margin ?? const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.size),
        ),
        child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: FittedBox(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              child: widget.user?.avt != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl + widget.user!.avt.toString(),
                      height: widget.size,
                      width: widget.size,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/blank-profile-picture.png',
                      height: widget.size,
                      width: widget.size,
                      fit: BoxFit.cover,
                    )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
