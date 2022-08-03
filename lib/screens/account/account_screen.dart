import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/setting/language_setting_screen.dart';
import 'package:traveling_social_app/screens/setting/notification_screen.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';
import 'package:traveling_social_app/widgets/icon_gradient.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/my_list_tile.dart';

import '../../constants/app_theme_constants.dart';
import '../../widgets/user_avt.dart';
import '../../widgets/username_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          BaseSliverAppBar(
              title: AppLocalizations.of(context)!.account, actions: [])
        ];
      },
      body: Container(
        color: Colors.grey.shade50,
        child: Column(
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
                        horizontal: 10, vertical: 10),
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
              onClick: () {},
              leading: const LinearGradiantMask(
                child: Icon(
                  Icons.ac_unit_outlined,
                  color: Colors.white,
                  size: kDefaultBottomNavIconSize,
                ),
              ),
              title: AppLocalizations.of(context)!.following,
            ),
            MyListTile(
              onClick: () {},
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
          ],
        ),
      ),
    );
  }
}
