import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_event.dart';
import 'package:traveling_social_app/screens/account/current_user_questions_screen.dart';
import 'package:traveling_social_app/screens/message/bloc/chat_bloc.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/setting/language_setting_screen.dart';
import 'package:traveling_social_app/screens/setting/notification_screen.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';
import 'package:traveling_social_app/widgets/icon_gradient.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/my_list_tile.dart';

import '../../bloc/post/post_bloc.dart';
import '../../bloc/story/story_bloc.dart';
import '../../constants/app_theme_constants.dart';
import '../../widgets/username_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../follow/follower_screen.dart';
import '../follow/following_screen.dart';
import '../review/current_user_review_post_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          BaseSliverAppBar(
              title: AppLocalizations.of(context)!.account, actions: const [])
        ];
      },
      body: Container(
        color: Colors.grey.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, CurrentUserProfileScreen.route());
                },
                child: Ink(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CurrentUserAvt(
                          size: 40,
                          onTap: () {},
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            UsernameText(
                              username: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user
                                  .username,
                            ),
                            Text(
                              AppLocalizations.of(context)!.viewYourProfile,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const MyDivider(width: 3),
            MyListTile(
              onClick: () => Navigator.push(context, FollowingScreen.route()),
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.ac_unit_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              title: AppLocalizations.of(context)!.following,
            ),
            MyListTile(
              onClick: () => Navigator.push(context, FollowerScreen.route()),
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.ac_unit_outlined,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.follower,
            ),
            const MyDivider(width: 2.5),
            MyListTile(
              onClick: () =>
                  Navigator.push(context, CurrentUserReviewPostScreen.route()),
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.ac_unit_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              title: AppLocalizations.of(context)!.review,
            ),
            // QUESTION
            MyListTile(
              onClick: () =>
                  Navigator.push(context, CurrentUserQuestionsScreen.route()),
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.ac_unit_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              title: AppLocalizations.of(context)!.question,
            ),
            const MyDivider(width: 2.5),
            MyListTile(
              onClick: () {},
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.drafts,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.drafts,
            ),
            const MyDivider(width: 2.5),
            MyListTile(
              onClick: () {
                Navigator.push(context, ChatGroupsScreen.route());
              },
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.messenger,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.message,
            ),
            const MyDivider(width: 2.5),
            MyListTile(
              onClick: () {
                Navigator.push(context, LanguageSettingScreen.route());
              },
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.language,
            ),
            MyListTile(
              onClick: () {
                Navigator.push(context, NotificationSettingScreen.route());
              },
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.notification,
            ),
            MyListTile(
              onClick: () {
                showAboutDialog(context: context);
              },
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.aboutUs,
            ),
            const MyDivider(width: 2.5),

            // Button Logout
            MyListTile(
              onClick: () {
                // showAboutDialog(context: context);
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      //TODO: translate
                      title: Text( AppLocalizations.of(context)!.notification,),
                      content: Text("Bạn có chắc muốn đăng xuất?"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text("Đồng ý"),
                          onPressed: () {
                            context.read<PostBloc>().add(Reset());
                            context.read<StoryBloc>().add(ResetStoryState());
                            context.read<ChatBloc>().add((ClearGroup()));
                            context
                                .read<AuthenticationBloc>()
                                .add(AuthenticationLogoutRequested());
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text("Hủy"),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    );
                  },
                );
              },
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.logOut,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
