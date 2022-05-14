import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Content.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

class StoryFullScreen extends StatefulWidget {
  const StoryFullScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  _StoryFullScreenState createState() => _StoryFullScreenState();
}

class _StoryFullScreenState extends State<StoryFullScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  String? currentImg;
  int itemCount = 0;

  nextImage() {
    if (currentIndex != itemCount - 1) {
      currentIndex = currentIndex + 1;
      _getImage(currentIndex);
    }
  }

  prevImages() {
    if (currentIndex >= 1) {
      currentIndex = currentIndex - 1;
      _getImage(currentIndex);
    }
  }

  int countContents() {
    if (widget.post.contents != null) {
      setState(() {
        itemCount = widget.post.contents!.length;
      });
    }
    return 0;
  }

  _getImage(int i) {
    List<Content>? contents = widget.post.contents;
    if (contents != null &&
        contents.isNotEmpty &&
        contents[i].attachment != null) {
      String? string = contents[i].attachment?.name.toString();
      setState(() {
        currentImg = string;
      });
    }
  }

  String _getTimeAgo() {
    return Jiffy(widget.post.createDate).fromNow();
  }

  @override
  void initState() {
    countContents();
    _getImage(currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Material(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.black87),
                child: Container(
                  padding: const EdgeInsets.only(top: 90),
                  // decoration: const BoxDecoration(color: Colors.black87),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //DIVIDER
                      itemCount > 1
                          ? Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: widget.post.contents == null
                                      ? []
                                      : List.generate(
                                          itemCount,
                                          (index) => Container(
                                            width: (size.width ~/
                                                    (widget.post.contents
                                                            ?.length ??
                                                        1))
                                                .toDouble(),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            height: 2,
                                            child: Divider(
                                                height: 2,
                                                thickness: 2,
                                                color: currentIndex == index
                                                    ? Colors.white
                                                    : Colors.grey),
                                          ),
                                        ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 5),
                      //IMAGE
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: currentImg != null
                                ? DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: CachedNetworkImageProvider(
                                      currentImg != null
                                          ? (imageUrl + currentImg.toString())
                                          : "https://images.pexels.com/photos/11780519/pexels-photo-11780519.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //LEFT CLICK RIGHT LICK
            Positioned(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => prevImages(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => nextImage(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //USER AVATAR
            Positioned(
              top: 0,
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvatar(
                            size: 35,
                            user: widget.post.user!,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.user!.username.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                              Text(
                                _getTimeAgo(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            //STORY CAPTION
            widget.post.contents!.isEmpty
                ? Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: size.height * .1),
                      alignment: Alignment.center,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: ExpandableText(
                              text: widget.post.caption.toString(),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            //
            (widget.post.caption != null && widget.post.contents!.isNotEmpty)
                ? Positioned(
                    child: SizedBox(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandableText(
                          text: widget.post.caption.toString(),
                        ),
                      ),
                    ),
                    bottom: 80,
                  )
                : const SizedBox.shrink(),
            //COMMENT INPUT
            Positioned(
              child: Container(
                height: size.height * .1,
                constraints: const BoxConstraints(maxHeight: 80),
                alignment: Alignment.center,
                width: size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                  width: 1, color: kPrimaryLightColor),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.white10),
                            hintText: "Type in your text",
                            fillColor: Colors.white10),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
