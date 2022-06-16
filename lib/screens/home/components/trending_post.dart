import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class TrendingPost extends StatelessWidget {
  const TrendingPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '#1',
            style: TextStyle(fontSize: 30, color: Colors.black38),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in dignissim sapien, sed tempus erat. Vivamus vehicula ac turpis vestibulum fermentum. ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  'kddevit',
                  style: TextStyle(color: kPrimaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
