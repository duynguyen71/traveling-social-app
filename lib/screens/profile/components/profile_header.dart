import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/extension/string_apis.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_theme_constants.dart';
import '../../../models/user.dart';
import 'follow_count.dart';
import 'icon_with_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.user,
    required this.onTapAvt,
    required this.onTapBg,
    required this.buttons,
  });

  final User? user;

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
                          imageUrl: '$imageUrl${user?.background}',
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
                    padding: EdgeInsets.all(2.0),
                    onTap: () => onTapAvt(),
                    size: 150,
                    avt: user?.avt,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: kDefaultPadding / 2,
                  child: buttons,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  user == null || user!.fullName.isNullOrBlank
                      ? const SizedBox.shrink()
                      : Text(
                          '${user!.fullName}',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .6),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '@${user?.username ?? ''}',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FollowCount(
                          title: AppLocalizations.of(context)!.following,
                          count: user?.followingCounts),
                      FollowCount(
                          title: AppLocalizations.of(context)!.follower,
                          count: user?.followerCounts),
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
                            (user == null || user!.location == null)
                                ? const SizedBox.shrink()
                                : IconTextButton(
                                    text: (user!.location!.label ?? ''),
                                    icon: Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black87,
                                      size: 16,
                                    )),
                            const SizedBox(width: 10),
                            IconTextButton(
                              text: Jiffy(user == null ||
                                          user?.createDate == null
                                      ? DateTime.now()
                                      : DateTime.parse('${user?.createDate}'))
                                  .format('dd-MM-yyyy'),
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black87,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            user == null || user!.website.isNullOrBlank
                                ? const SizedBox.shrink()
                                : IconTextButton(
                                    text: '${user!.website}',
                                    icon: const Icon(
                                      Icons.link,
                                      color: Colors.black87,
                                      size: 16,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  user == null || user!.bio.isNullOrBlank
                      ? const SizedBox.shrink()
                      : Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            user?.bio ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
