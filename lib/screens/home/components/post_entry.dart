import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/Attachment.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/screens/comment/comment_screen.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/popup_menu_item.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../../../models/Content.dart';
import '../../../models/Reaction.dart';
import '../../../models/User.dart';
import '../../../services/post_service.dart';
import 'package:provider/provider.dart';

import '../../../view_model/user_view_model.dart';
import '../../../widgets/my_dialog.dart';

class PostEntry extends StatefulWidget {
  const PostEntry({Key? key, this.image, required this.post, this.padding}) : super(key: key);

  final String? image;
  final Post post;
final Padding? padding;
  @override
  State<PostEntry> createState() => _PostEntryState();
}

class _PostEntryState extends State<PostEntry>
    with AutomaticKeepAliveClientMixin {
  bool _isFavorite = false;
  final PostService _postService = PostService();
  final List<Attachment> _attachments = [];

  int _attachmentIndex = 0;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.reactionCount;
    _isFavorite = (myReaction != null);
    _getAttachments();
  }

  _getAttachments() {
    List<Content>? contents = widget.post.contents;
    List<Attachment> attachments = [];
    if (contents != null && contents.isNotEmpty) {
      for (int i = 0; i < contents.length; i++) {
        var content = contents[i];
        var attachment = content.attachment;
        if (attachment != null) {
          attachments.add(attachment);
        }
      }
    }
    setState(() {
      _attachments.addAll(attachments);
    });
  }

  List<Content> getContents() {
    if (widget.post.contents != null) {
      return widget.post.contents!;
    }
    return [];
  }

  _hide() {}

  Reaction? get myReaction => widget.post.myReaction;

  String? get mainCaption => widget.post.caption;

  User? get currentUser => context.read<UserViewModel>().user;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
          ),
          bottom: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER AVT AVT
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              context.read<UserViewModel>().equal(widget.post.user)
                  ? CurrentUserAvt(
                      margin: EdgeInsets.zero,
                      size: 40,
                      onTap: () => ApplicationUtility.navigateToScreen(
                          context, const CurrentUserProfileScreen()),
                    )
                  : UserAvatar(
                      size: 40,
                      user: widget.post.user!,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        ApplicationUtility.navigateToScreen(context,
                            ProfileScreen(userId: widget.post.user!.id!));
                      },
                    ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.post.user!.username.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    Jiffy(widget.post.createDate).fromNow(),
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton(
                child: Container(
                  height: 36,
                  width: 48,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.more_horiz, color: Colors.black87),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                color: Colors.grey.shade100,
                itemBuilder: (context) {
                  return context.read<UserViewModel>().equal(widget.post.user)
                      ? const <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'DELETE',
                            child: MyPopupMenuItem(
                                title: 'DELETE',
                                iconData: Icons.visibility_off),
                          ),
                        ]
                      : <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'FOLLOW',
                            child: MyPopupMenuItem(
                                title:
                                    'Follow ${widget.post.user!.username.toString()}',
                                iconData: Icons.person),
                          ),
                          const PopupMenuItem<String>(
                            value: 'LOVE',
                            child: MyPopupMenuItem(
                                title: 'Love', iconData: Icons.person),
                          ),
                        ];
                },
                onSelected: (string) {
                  switch (string) {
                    case "DELETE":
                      {
                        showHidePostAlert(context);
                        break;
                      }
                  }
                },
                padding: EdgeInsets.zero,
                elevation: 0,
              )
            ],
          ),
          //CAPTION
          mainCaption.toString().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ExpandableText(
                    text: mainCaption.toString().trim(),
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                )
              : const SizedBox.shrink(),

          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (_attachments.isEmpty ||
                        !_attachments.asMap().containsKey(_attachmentIndex))
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8.0),
                        child: CachedNetworkImage(
                          cacheKey:
                              _attachments[_attachmentIndex].name.toString(),
                          fit: BoxFit.contain,
                          imageUrl: imageUrl +
                              _attachments[_attachmentIndex].name.toString(),
                          placeholder: (context, url) {
                            return AspectRatio(
                              aspectRatio: 4 / 5,
                              child: Container(
                                  color: Colors.grey[400],
                                  child: const Center(
                                      child: CupertinoActivityIndicator())),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const AspectRatio(aspectRatio: 4 / 5),
                        ),
                      ),
              ),
              _attachments.length > 1
                  ? Positioned(
                      child: RoundedIconButton(
                        onClick: () {
                          if (_attachmentIndex < getContents().length - 1) {
                            setState(() {
                              _attachmentIndex = _attachmentIndex + 1;
                            });
                          }
                        },
                        icon: Icons.arrow_forward_ios,
                        iconColor: _attachmentIndex < 1
                            ? Colors.black12
                            : Colors.white,
                      ),
                      right: 10,
                    )
                  : const SizedBox.shrink(),
              _attachments.length > 1
                  ? Positioned(
                      child: RoundedIconButton(
                        onClick: () {
                          if (_attachmentIndex >= 1) {
                            setState(() {
                              _attachmentIndex = _attachmentIndex - 1;
                            });
                          }
                        },
                        icon: Icons.arrow_back_ios,
                        iconColor: _attachmentIndex <= (_attachments.length - 1)
                            ? Colors.black12
                            : Colors.white,
                      ),
                      left: 10,
                    )
                  : const SizedBox.shrink(),
              _attachments.length > 1
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black87.withOpacity(.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: '${_attachmentIndex + 1}'),
                            TextSpan(text: ' / ${_attachments.length}')
                          ], style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          //BUTTONS
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.05),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _postService.reactionPost(
                              postId: widget.post.id!,
                              reactionId: _isFavorite ? null : 1);
                          setState(() {
                            if (_isFavorite) {
                              _isFavorite = false;
                              _likeCount--;
                            } else {
                              _isFavorite = true;
                              _likeCount++;
                            }
                          });
                        },
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: child.key == const ValueKey('icon1')
                                ? Tween<double>(
                                        begin: !_isFavorite ? 1 : 1.5, end: 1)
                                    .animate(animation)
                                : Tween<double>(
                                        begin: _isFavorite ? 1 : 1.5, end: 1)
                                    .animate(animation),
                            child: child,
                          ),
                          child: _isFavorite
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
                      Text(_likeCount.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  CommentScreen(
                                postId: widget.post.id!,
                                myComments: widget.post.myComments,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        widget.post.commentCount.toString(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: Colors.black45,
                        ),
                      ),
                      const Text('Share'),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showHidePostAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this Post"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Delete",
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                context.read<PostViewModel>().removePost(postId: postId!);
                context
                    .read<CurrentUserPostViewModel>()
                    .removePost(postId: postId!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int? get postId => widget.post.id;

  @override
  bool get wantKeepAlive => true;
}
