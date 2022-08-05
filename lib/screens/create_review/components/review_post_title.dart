import 'package:flutter/material.dart';

import '../../../constants/app_theme_constants.dart';

class ReviewPostTitle extends StatelessWidget {
  const ReviewPostTitle({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: reviewPostTitleTextStyle,
      ),
    );
  }
}
