import 'package:flutter/material.dart';

class NavigationItem {
  String title;
  IconData iconData;

  NavigationItem({
    required this.title,
    required this.iconData,
  });
}

List<NavigationItem> navigationItems = [
  NavigationItem(title: "New", iconData: Icons.create),
  NavigationItem(title: "Message", iconData: Icons.message_outlined),
  NavigationItem(title: "News", iconData: Icons.ac_unit),
  NavigationItem(title: "Setting", iconData: Icons.settings),
  NavigationItem(title: "About us", iconData: Icons.ac_unit),
  NavigationItem(title: "Log out", iconData: Icons.logout),
];
