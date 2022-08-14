import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/Base_review_post_response.dart';

import '../../../widgets/my_divider.dart';
import '../../../widgets/rounded_image_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewPostEntry extends StatelessWidget {
  const ReviewPostEntry(
      {Key? key,
      required this.post,
      this.coverImgHeight,
      this.showFooter = true, required this.onTap})
      : super(key: key);
  final BaseReviewPostResponse post;
  final double? coverImgHeight;
  final bool showFooter;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        // color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedImageContainer(
                  name: post.coverImage?.name,
                  height: coverImgHeight ?? 60,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.title.toString(),
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            showFooter
                ? Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '${post.user?.username}',
                                style: const TextStyle(color: Colors.blue)),
                            const TextSpan(text: ' - '),
                            TextSpan(
                                text: timeago.format(
                                    DateTime.parse(post.createDate.toString()),
                                    locale: Localizations.localeOf(context)
                                        .languageCode)),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        padding: const EdgeInsets.all(4.0),
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.black54,
                          size: 18,
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            const MyDivider(color: Colors.black12, width: .5),
          ],
        ),
      ),
    );
  }
}
