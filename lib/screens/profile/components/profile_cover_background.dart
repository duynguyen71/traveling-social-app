import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/screens/profile/components/profile_avt_and_cover.dart';

import '../../../authentication/bloc/authentication_state.dart';
import 'follow_count.dart';
import 'icon_with_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileCoverBackground extends StatelessWidget {
  const ProfileCoverBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //AVT
            const ProfileAvtAndCover(),
            //USER INFO
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child:
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        builder: (context, value) => Text(
                          '@${value.user.username}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 18),
                        ),
                        listener: (context, state) =>
                            state.user.username.toString(),
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
                              const IconWithText(
                                  text: "Ho Chi Minh city",
                                  icon: Icons.location_on_outlined),
                              const SizedBox(width: 10),
                              IconWithText(
                                  // text: AppLocalizations.of(context)!
                                  //     .joinedDate(timeago.format(DateTime.parse(
                                  //         context
                                  //             .select((AuthenticationBloc
                                  //                     authBloc) =>
                                  //                 authBloc.state.user)
                                  //             .createDate
                                  //             .toString()))),
                                  text: Jiffy(context
                                          .select(
                                              (AuthenticationBloc authBloc) =>
                                                  authBloc.state.user)
                                          .createDate
                                          .toString())
                                      .format('dd-MM-yyyy'),
                                  icon: Icons.calendar_today_outlined),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              IconWithText(
                                  text: "Live in",
                                  icon: Icons.location_on_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //BIO
                    SizedBox(
                      child: const Divider(indent: 1, thickness: 1),
                      width: size.width * .7,
                    ),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: ((context, state) => state.user.bio),
                      builder: (context, state) => Text(
                        '${state.user.bio}',
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
