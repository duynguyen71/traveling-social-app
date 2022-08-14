import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';

class RoundedImageContainer extends StatelessWidget {
  const RoundedImageContainer({Key? key, this.name, required this.height})
      : super(key: key);
  final String? name;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: CachedNetworkImage(
              imageUrl: '$imageUrl$name',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
