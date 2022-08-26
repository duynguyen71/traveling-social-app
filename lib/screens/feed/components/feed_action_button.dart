import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_theme_constants.dart';

class FeedActionButton extends StatelessWidget {
  const FeedActionButton({Key? key, required this.onClick, required this.asset})
      : super(key: key);

  final Function onClick;
  final String asset;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Ink(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(5.0),
              height: 30,
              width: 30,
              child: SvgPicture.asset(
                asset,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
