import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/post_content.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({Key? key, required this.story, required this.onClick})
      : super(key: key);

  final Post story;
  final Function onClick;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with AutomaticKeepAliveClientMixin {

  String? image;

  @override
  void initState() {
    List<Content>? contents = widget.story.contents;
    if (contents != null && contents.isNotEmpty) {
      image = (contents[0].attachment?.name.toString());
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: kDefaultStoryCardHeight,
      constraints: const BoxConstraints(
        minHeight: kDefaultStoryCardHeight,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onClick(),
          child: Ink(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black87, Colors.black45],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: image != null
                            ? DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                    '$imageUrl$image'),
                              )
                            : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: (widget.story.caption.toString().isNotEmpty &&
                              image == null)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  widget.story.caption.toString(),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox.expand(),
                    ),
                  ),
                  //AVT
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: UserAvatar(
                      size: 25,
                      avt: '${widget.story.user!.avt}',
                      onTap: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
