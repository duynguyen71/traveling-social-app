import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/models/Author.dart';

import '../../../authentication/bloc/authentication_bloc.dart';
import '../../../constants/app_theme_constants.dart';
import '../../../widgets/my_outline_button.dart';
import '../../../widgets/user_avt.dart';
import '../../profile/components/follow_count.dart';
import '../../profile/profile_screen.dart';

class AuthTag extends StatefulWidget {
  const AuthTag({
    Key? key,
    required this.auth,
    required this.onTapFollow,
  }) : super(key: key);

  @override
  State<AuthTag> createState() => _AuthTagState();

  final Author auth;
  final Function onTapFollow;
}

class _AuthTagState extends State<AuthTag> with AutomaticKeepAliveClientMixin {
  Author get author => widget.auth;

  _navigateToAuthorProfile() {
    if (context.read<AuthenticationBloc>().state.user.id == author.id!) return;
    Navigator.push(context, ProfileScreen.route(author.id!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.aboutAuthor,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: UserAvatar(
                    avt: author.avt,
                    size: 40,
                    onTap: _navigateToAuthorProfile,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author.username!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: kPrimaryLightColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          context.read<AuthenticationBloc>().state.user.id !=
                                  author.id
                              ? SizedBox(
                                  width: 100,
                                  child: MyOutlineButton(
                                    onClick: () => widget.onTapFollow(),
                                    text: author.isFollowing
                                        ? AppLocalizations.of(context)!
                                            .following
                                        : AppLocalizations.of(context)!.follow,
                                    color: author.isFollowing
                                        ? kPrimaryColor
                                        : null,
                                    textColor: author.isFollowing
                                        ? Colors.white
                                        : null,
                                    minWidth: 80,
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FollowCount(
                                title: AppLocalizations.of(context)!.review,
                                count: author.numOfReviewPost),
                            FollowCount(
                                title: AppLocalizations.of(context)!.post,
                                count: author.numOfPost),
                            FollowCount(
                                title: AppLocalizations.of(context)!.follower,
                                count: author.numOfFollower),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
