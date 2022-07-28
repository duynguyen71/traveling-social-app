import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/edit_profile/edit_profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonEditProfile extends StatelessWidget {
  const ButtonEditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          style: BorderStyle.solid,
          color: kPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        onPressed: () {
          ApplicationUtility.navigateToScreen(
              context, const EditProfileScreen());
        },
        child: Text(
          AppLocalizations.of(context)!.editProfile,
          style: const TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }
}
