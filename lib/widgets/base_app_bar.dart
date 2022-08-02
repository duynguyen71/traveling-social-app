import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  const BaseAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // leading: Row(
      //   children: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: const Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.blue,
      //       ),
      //     ),
      //     Text(
      //       AppLocalizations.of(context)!.setting,
      //       style: const TextStyle(
      //         color: Colors.blue,
      //       ),
      //     ),
      //   ],
      // ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black87,
          icon: const Icon(Icons.arrow_back_ios)),

      // leadingWidth: 200,
      title: Text(
        title,
        style: kDefaultAppBarTextTitleStyle,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
