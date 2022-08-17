import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/review/review_post_detail_screen.dart';

import '../../../models/Base_review_post_response.dart';
import '../../create_review/components/cover_image_container.dart';

class ReviewPostCard extends StatefulWidget {
  const ReviewPostCard({
    Key? key,
    required this.reviewPost,
  }) : super(key: key);

  final BaseReviewPostResponse reviewPost;

  @override
  State<ReviewPostCard> createState() => _ReviewPostCardState();
}

class _ReviewPostCardState extends State<ReviewPostCard>
    with AutomaticKeepAliveClientMixin {
  BaseReviewPostResponse get reviewPost => widget.reviewPost;

  _onTap() {
    Navigator.push(
        context, ReviewPostDetailScreen.route(widget.reviewPost.id!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(right: 10),
        constraints: BoxConstraints(maxWidth: size.width * .95),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cover image
            CoverImageContainer(
              child: Container(
                color: Colors.grey.shade200,
                child: ClipRRect(
                  borderRadius: kReviewPostBorderRadius,
                  child: CachedNetworkImage(
                    alignment: Alignment.center,
                    imageUrl: '$imageUrl${reviewPost.coverPhoto?.name}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onTap,
                  child: Ink(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      width: size.width * .6,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${reviewPost.title}",
                            style: const TextStyle(
                              fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          SizedBox(
                            width: size.width * .35,
                            child: Text(
                              reviewPost.user!.username!,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
