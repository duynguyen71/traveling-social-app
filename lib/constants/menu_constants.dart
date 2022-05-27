import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/popup_menu_item.dart';

List<PopupMenuEntry<String>> currentUserPostPopupMenuItems =
    <PopupMenuEntry<String>>[
  const PopupMenuItem<String>(
    value: 'DELETE',
    child: MyPopupMenuItem(
        title: 'DELETE',
        iconData: Icons.visibility_off,
        color: Colors.redAccent),
  ),
];
