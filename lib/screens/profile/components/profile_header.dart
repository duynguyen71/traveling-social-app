import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_theme_constants.dart';
import 'button_edit_profile.dart';
import 'follow_count.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'icon_with_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {Key? key,
      required this.username,
      this.followingCount = 0,
      this.followerCount = 0,
      this.avt,
      this.bgImage,
      this.joinedDate,
      required this.onTapAvt,
      required this.onTapBg, required this.buttons})
      : super(key: key);
  final String? username;
  final int? followingCount, followerCount;
  final String? avt, bgImage, joinedDate;
  final Function onTapAvt, onTapBg;
  final Widget buttons;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //AVT
          SizedBox(
            height: size.height * .4,
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  height: (size.height * .4 - 80),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => onTapBg(),
                    //BACKGROUND
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: '$imageUrl$bgImage',
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/home_bg.png",
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
                //CURRENT USER AVT
                Positioned(
                  bottom: 0,
                  left: kDefaultPadding,
                  child: UserAvatar(
                    onTap: () => onTapAvt(),
                    size: 150,
                    avt: avt,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: kDefaultPadding / 2,
                  // child: Container(
                  //   constraints: const BoxConstraints(minWidth: 130),
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   height: 40,
                  //   child: const ButtonEditProfile(),
                  // ),
                  child: buttons,
                ),
              ],
            ),
          ),
          //USER INFO
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      '$username',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FollowCount(
                          title: AppLocalizations.of(context)!.following,
                          count: followingCount),
                      FollowCount(
                          title: AppLocalizations.of(context)!.follower,
                          count: followerCount),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const IconTextButton(
                                text: "Ho Chi Minh city",
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black87,
                                  size: 16,
                                )),
                            const SizedBox(width: 10),
                            IconTextButton(
                                text: Jiffy(joinedDate == null
                                        ? DateTime.now()
                                        : DateTime.parse('$joinedDate'))
                                    .format('dd-MM-yyyy'),
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.black87,
                                  size: 16,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            IconTextButton(
                                text: "Live in",
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black87,
                                  size: 16,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}