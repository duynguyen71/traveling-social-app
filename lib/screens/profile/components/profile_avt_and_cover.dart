import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/profile/components/title_with_number.dart';

import '../../../constants/app_theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../models/User.dart';
import '../../../view_model/user_viewmodel.dart';
import '../../../widgets/user_avt.dart';
import 'button_edit_profile.dart';

class ProfileAvtAndCover extends StatelessWidget {
  const ProfileAvtAndCover({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .4,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: (size.height * .4) - 50,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //CURRENT USER VATAR
          Positioned(
            bottom: 0,
            left: kDefaultPadding,
            child: Selector<UserViewModel, User>(
              selector: (p0, p1) => p1.user!,
              builder: (context, value, child) => UserAvatar(
                user: value,
                size: 150,
                onTap: () {},
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: kDefaultPadding / 2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 130),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 40,
              child: const ButtonEditProfile(),
            ),
          ),
        ],
      ),
    );
  }
}
