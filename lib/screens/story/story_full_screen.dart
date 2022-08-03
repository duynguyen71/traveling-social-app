import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/screens/story/story_context_menu.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../utilities/application_utility.dart';
import '../../widgets/user_avt.dart';
import '../profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryFullScreen extends StatefulWidget {
  const StoryFullScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  _StoryFullScreenState createState() => _StoryFullScreenState();
}

class _StoryFullScreenState extends State<StoryFullScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  int itemCount = 0;

  nextImage() {
    if (currentIndex < widget.post.contents!.length - 1) {
      setState(() => currentIndex += 1);
    }
  }

  prevImages() {
    if (currentIndex >= 1) {
      setState(() => currentIndex -= 1);
    }
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //IMAGE
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: widget.post.contents != null &&
                              widget.post.contents!
                                  .asMap()
                                  .containsKey(currentIndex)
                          ? CachedNetworkImage(
                              imageUrl:
                                  '$imageUrl${widget.post.contents![currentIndex].attachment?.name}',
                              imageBuilder: (context, a) => Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth, image: a),
                                ),
                              ),
                              errorWidget: (context, url, a) =>
                                  const SizedBox.shrink(),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
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
              top: size.height * .05,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          //USERNAME AND CREATED TIME
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              UserAvatar(
                                size: 40,
                                avt: widget.post.user!.avt,
                                onTap: () {
                                  ApplicationUtility.pushAndReplace(
                                      context,
                                      ProfileScreen(
                                          userId: widget.post.user!.id!));
                                },
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
                                    // _getTimeAgo(),
                                    timeago.format(
                                        DateTime.parse(
                                            widget.post.createDate.toString()),
                                        locale: Localizations.localeOf(context)
                                            .languageCode),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        StoryContextMenu(
                          isCurrentUser: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user
                                  .id ==
                              widget.post.user!.id!,
                          user: widget.post.user!,
                          storyId: widget.post.id!,
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (widget.post.contents != null &&
                          widget.post.contents!.length > 1)
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
                                      widget.post.contents!.length,
                                      (index) => Container(
                                        width: (size.width ~/
                                                (widget.post.contents?.length ??
                                                    1))
                                            .toDouble(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        height: 2,
                                        child: Divider(
                                            thickness:
                                                currentIndex == index ? 1.5 : 1,
                                            color: currentIndex == index
                                                ? Colors.white
                                                : Colors.grey.withOpacity(.5)),
                                      ),
                                    ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            //STORY CAPTION
            widget.post.contents!.isEmpty
                ? Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: size.height * .2),
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
                                  fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            //CAPTIONS
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
            //MESSAGE INPUT
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
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                  width: 1, color: kPrimaryLightColor),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.white10),
                            hintText:
                                AppLocalizations.of(context)!.typeInYourText,
                            fillColor: Colors.white10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
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
