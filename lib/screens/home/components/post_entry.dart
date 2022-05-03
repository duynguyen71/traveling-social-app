import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

class PostEntry extends StatefulWidget {
  const PostEntry({Key? key, this.image, required this.post}) : super(key: key);

  final String? image;
  final Post post;

  @override
  State<PostEntry> createState() => _PostEntryState();
}

class _PostEntryState extends State<PostEntry> with TickerProviderStateMixin {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  AVT
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 UserAvatar(size: 40,user: widget.post.user!,),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "username",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "30m ago",
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: widget.image == null
                ? SizedBox.shrink()
                : CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.image!,
                    placeholder: (context, url) {
                      return const CircularProgressIndicator();
                    },
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: child.key == const ValueKey('icon1')
                              ? Tween<double>(
                                      begin: !isFavorite ? 1 : 1.5, end: 1)
                                  .animate(animation)
                              : Tween<double>(
                                      begin: isFavorite ? 1 : 1.5, end: 1)
                                  .animate(animation),
                          child: child,
                        ),
                        child: isFavorite
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                key: ValueKey('icon1'),
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.black45,
                                key: ValueKey('icon2'),
                              ),
                      ),
                    ),
                    const Text('1K'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline)),
                    Text('120 comments'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                    Text('Share'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
