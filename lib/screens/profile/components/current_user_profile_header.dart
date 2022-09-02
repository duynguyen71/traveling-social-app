import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/extension/string_apis.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';

import '../../../authentication/bloc/authentication_state.dart';
import 'follow_count.dart';
import 'icon_with_text.dart';

class CurrentUserProfileHeader extends StatelessWidget {
  const CurrentUserProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //AVT
          const ProfileAvtAndCover(),
          //USER INFO
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
                  // FullName
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    builder: (context, value) {
                      var fullName = value.user.fullName;
                      return fullName.isNullOrBlank
                          ? const SizedBox.shrink()
                          : Text(
                              '$fullName',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .6),
                            );
                    },
                    listener: (context, state) => state.user.fullName,
                  ),
                  // Username
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child:
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      builder: (context, value) => Text(
                        '@${value.user.username}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                      listener: (context, state) => state.user.username,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) => FollowCount(
                            title: AppLocalizations.of(context)!.following,
                            count: state.user.followingCounts),
                        listener: (p0, p1) => p1.user.followingCounts,
                      ),
                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) => FollowCount(
                            title: AppLocalizations.of(context)!.follower,
                            count: state.user.followerCounts),
                        listener: (p0, p1) => p1.user.followerCounts,
                      ),
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
                            // Location
                            BlocConsumer<AuthenticationBloc,
                                AuthenticationState>(
                              listener: (context, state) => state.user.location,
                              builder: (context, state) {
                                return state.user.location == null
                                    ? const SizedBox.shrink()
                                    : IconTextButton(
                                        text: state.user.location?.label ?? '',
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black87,
                                          size: 16,
                                        ));
                              },
                            ),
                            const SizedBox(width: 10),
                            // Joined Date
                            IconTextButton(
                                text: Jiffy(context
                                        .select((AuthenticationBloc authBloc) =>
                                            authBloc.state.user)
                                        .createDate
                                        .toString())
                                    .format('dd-MM-yyyy'),
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.black87,
                                  size: 16,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Website
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          builder: (BuildContext context, state) {
                            var website = state.user.website;
                            return website.isNullOrBlank
                                ? const SizedBox.shrink()
                                : IconTextButton(
                                    text: state.user.website ?? '',
                                    icon: const Icon(
                                      Icons.link,
                                      color: Colors.black87,
                                      size: 16,
                                    ),
                                  );
                          },
                          listener: (context, state) => state.user.website,
                        ),
                      ],
                    ),
                  ),
                  // Bio
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    builder: (context, value) {
                      var bio = value.user.bio;
                      return bio.isNullOrBlank
                          ? const SizedBox.shrink()
                          : Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                bio ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                            );
                    },
                    listener: (context, state) => state.user.bio,
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
