import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {Key? key,
      required this.onClick,
      required this.leading,
      required this.title,
      this.padding = kDefaultListItemPadding})
      : super(key: key);
  final Function onClick;
  final Widget leading;
  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Ink(
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading,
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
