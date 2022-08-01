import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/widgets/icon_gradient.dart';
import 'package:traveling_social_app/widgets/my_list_tile.dart';

import '../../widgets/user_avt.dart';
import '../../widgets/username_text.dart';

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
            SliverAppBar(
              pinned: true,
              title: Text(
                'Cá nhân',
                style: TextStyle(color: Colors.black87),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: kDefaultHorizPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatar(
                    size: 40,
                    onTap: () {},
                    isActive: false,
                    avt: context.read<AuthenticationBloc>().state.user.avt,
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
                      Text("View your profile"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MyListTile(
              onClick: () {},
              leading: LinearGradiantMask(
                child: Icon(
                 Icons.ac_unit_outlined,
                  color: Colors.white,
                ),
              ),
              title: 'Following',
            ),
            MyListTile(
              onClick: () {},
              leading: Icon(Icons.person),
              title: 'Follower',
            ),
            MyListTile(
              onClick: () {},
              leading: Icon(Icons.person),
              title: 'Following',
            ),
          ],
        ));
  }
}
