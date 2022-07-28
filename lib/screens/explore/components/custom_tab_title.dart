import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class CustomTabTitle extends StatelessWidget {
  const CustomTabTitle(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.label})
      : super(key: key);

  final Function onTap;
  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(),
        splashColor: kPrimaryColor.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Icon(iconData, size: 20, color: kPrimaryColor),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(label),
                  ),
                ],
              ),
              // Visibility(
              //   visible: this.count.isNotEmpty,
              //   child: Positioned(
              //     right: 0,
              //     top: 0,
              //     child: Container(
              //       alignment: Alignment.center,
              //       height: 15,
              //       width: 15,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: kPrimaryLightColor,
              //       ),
              //       child: Text(
              //         this.count.isEmpty ? "" : this.count,
              //         style: TextStyle(color: Colors.white, fontSize: 10),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
