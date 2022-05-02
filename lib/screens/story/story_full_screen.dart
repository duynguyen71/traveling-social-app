import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:provider/provider.dart';

class StoryFullScreen extends StatefulWidget {
  const StoryFullScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  _StoryFullScreenState createState() => _StoryFullScreenState();
}

class _StoryFullScreenState extends State<StoryFullScreen> {
  final PostViewModel _postViewModel = PostViewModel();

  late String text;

  nextImage() {}

  prevImages() {}

  _onClose() {
    _postViewModel.setCurrentStoryIndex = 0;
  }

  @override
  void initState() {
    text = 'There are many variations of passages of Lorem Ipsum available, '
        'but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t '
        'look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t '
        'anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat '
        'predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over '
        '200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. '
        'The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.black87),
                child: Container(
                  padding: const EdgeInsets.only(top: 100),
                  decoration: const BoxDecoration(color: Colors.black87),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //DIVIDER
                      widget.post.contents != null &&
                              widget.post.contents!.length > 1
                          ? Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: widget.post.contents == null
                                      ? []
                                      : widget.post.contents!
                                          .map(
                                            (e) => Container(
                                              width: (size.width ~/
                                                      (widget.post.contents
                                                              ?.length ??
                                                          1))
                                                  .toDouble(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              height: 2,
                                              child: const Divider(
                                                  height: 2,
                                                  thickness: 2,
                                                  color: Colors.white),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      //IMAGE
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://images.pexels.com/photos/11780519/pexels-photo-11780519.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                              ),
                            ),
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
                          const UserAvatar(size: 35),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "username",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                              Text(
                                "30m ago",
                                style: TextStyle(
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
            Positioned(
              child: SizedBox(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandableText(
                    text: text,
                  ),
                ),
              ),
              bottom: 80,
            ),
            //COMMENT INPUT
            Positioned(
              child: Container(
                height: size.height * .1,
                constraints: const BoxConstraints(maxHeight: 80),
                alignment: Alignment.center,
                width: size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.black87),
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
}
