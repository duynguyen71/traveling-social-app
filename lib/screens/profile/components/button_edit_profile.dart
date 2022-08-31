import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/update_base_user_info.dart';

import '../edit_profile.dart';

class ButtonEditProfile extends StatelessWidget {
  const ButtonEditProfile(
      {Key? key,
      required this.onUpdateCallback,
      required this.onTapUserAvt,
      required this.onTapCoverBg})
      : super(key: key);

  final Future<void> Function(UpdateBaseUserInfo userInfo) onUpdateCallback;
  final Function(BuildContext context) onTapUserAvt;
  final Function(BuildContext context) onTapCoverBg;

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
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              context: context,
              builder: (context) {
                return EditProfile(
                  onUpdateCallback: onUpdateCallback,
                  onTapUserAvt: (BuildContext context) {
                    onTapUserAvt(context);
                  },
                  onTapCoverBg: (BuildContext context) {
                    onTapCoverBg(context);
                  },
                );
              },
              backgroundColor: Colors.transparent,
              isDismissible: true,
              isScrollControlled: true);
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
