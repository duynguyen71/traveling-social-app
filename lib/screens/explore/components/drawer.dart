import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_event.dart';
import 'package:traveling_social_app/bloc/locale/locale_cubit.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/nav_item.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/repository/authentication_repository/authentication_repository.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/screens/message/bloc/chat_bloc.dart';
import 'package:traveling_social_app/screens/message/chat_groups_screen.dart';
import 'package:traveling_social_app/screens/restartWidget.dart';
import 'package:traveling_social_app/screens/setting/setting_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/view_model/story_view_model.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                    // context.read<PostViewModel>().clear();
                    context.read<StoryViewModel>().clear();
                    context.read<CurrentUserPostViewModel>().clear();
                    context.read<ChatBloc>().add(InitialChatGroup());
                    context.read<PostBloc>().add(Reset());
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
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    Scaffold.of(context).closeDrawer();
  }
}
