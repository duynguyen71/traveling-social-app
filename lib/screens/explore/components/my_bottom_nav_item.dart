import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/icon_gradient.dart';

import '../../../constants/app_theme_constants.dart';

class MyBottomNavItem extends StatelessWidget {
  const MyBottomNavItem(
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
                child: Icon(iconData,
                    color: isSelected
                        ? Colors.black54
                        : Colors.grey.withOpacity(.5),
                    size: 24.0,),
              ),
              //nav label
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.black54 : Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
