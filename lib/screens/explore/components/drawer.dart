import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_event.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/setting/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../message/bloc/chat_bloc.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(kDefaultPadding),
          ),
          Column(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.message),
                leading: const Icon(Icons.message),
                onTap: () {
                  _closeDrawer(context);
                  Navigator.push(context, ChatGroupsScreen.route());
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.setting),
                leading: const Icon(Icons.settings),
                onTap: () {
                  _closeDrawer(context);
                  Navigator.push(context, SettingScreen.route());
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logOut),
                leading: const Icon(Icons.logout),
                onTap: () {
                  context.read<PostBloc>().add(Reset());
                  context.read<StoryBloc>().add(ResetStoryState());
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested());
                },
              ),
            ],
          )
          // const DrawerFooter(),
        ],
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    Scaffold.of(context).closeDrawer();
  }
}
