import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/widgets/icon_gradient.dart';

import 'number_badge.dart';

class BadgeBottomNavItem extends StatelessWidget {
  const BadgeBottomNavItem(
      {Key? key,
      required this.iconData,
      required this.label,
      required this.onClick,
      required this.isSelected})
      : super(key: key);

  final IconData iconData;
  final String label;
  final Function onClick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Ink(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: isSelected ? 1.2 : 1,
                child: SizedBox(
                  width: kDefaultBottomNavIconSize + 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        iconData,
                        // color: Colors.white,
                        color: isSelected
                            ? Colors.black54
                            : Colors.grey.withOpacity(.5),
                        size: kDefaultBottomNavIconSize,
                      ),
                      const Positioned(
                        child: NumberBadge(number: 12),
                        top: 0,
                        right: 0,
                      )
                    ],
                  ),
                ),
              ),
              //nav label
              Text(
                label,
                style: TextStyle(
                  // fontSize: isSelected ? 12 : 10,
                  fontSize: 10,
                  color: isSelected ? Colors.black54 : Colors.black26,
                  // color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
