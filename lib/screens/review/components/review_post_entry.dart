import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/Base_review_post_response.dart';

import '../../../widgets/my_divider.dart';
import '../../../widgets/rounded_image_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewPostEntry extends StatelessWidget {
  const ReviewPostEntry(
      {Key? key,
      // required this.post,
      this.coverImgHeight,
      this.showFooter = true,
      required this.onTap,
      required this.child,
      this.imageName,
      this.title, this.color})
      : super(key: key);
  final double? coverImgHeight;
  final bool showFooter;
  final Function onTap;
  final Widget child;
  final String? imageName, title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        // color: Colors.white,
        color: color,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                RoundedImageContainer(
                  name: '$imageName',
                  height: coverImgHeight ?? 60,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$title',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            child,
            const MyDivider(color: Colors.black12, width: .5),
          ],
        ),
      ),
    );
  }
}
