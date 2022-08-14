import 'package:flutter/material.dart';

import '../../../constants/app_theme_constants.dart';

class ReviewPostTitle extends StatelessWidget {
  const ReviewPostTitle({Key? key, required this.title, required this.padding})
      : super(key: key);
  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: reviewPostTitleTextStyle,
      ),
    );
  }
}
