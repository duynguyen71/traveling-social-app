import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/review_post.dart';
import 'package:traveling_social_app/screens/review/review_post_detail.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

class ReviewPlace extends StatefulWidget {
  const ReviewPlace({
    Key? key,
    required this.reviewPost,
  }) : super(key: key);

  final ReviewPost reviewPost;

  @override
  State<ReviewPlace> createState() => _ReviewPlaceState();
}

class _ReviewPlaceState extends State<ReviewPlace> {
  ReviewPost get reviewPost => widget.reviewPost;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        ApplicationUtility.navigateToScreen(context,  ReviewPostDetailScreen(id:reviewPost.id!));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        constraints: BoxConstraints(maxWidth: size.width * .95),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                  imageUrl: reviewPost.coverPhoto != null
                      ? imageUrl + reviewPost.coverPhoto!.name.toString()
                      : "https://images.pexels.com/photos/11593467/pexels-photo-11593467.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
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
                            "Hi ${reviewPost.title.toString()}!",
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.location_on_sharp,
                                  size: 12, color: Colors.black54),
                              Text(
                                "Lat da",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
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
}
