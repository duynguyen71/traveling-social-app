import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/generated/l10n.dart';
import 'package:traveling_social_app/models/attachment.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/screens/comment/comment_screen.dart';
import 'package:traveling_social_app/screens/explore/components/post_attachment_container.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/popup_menu_item.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:traveling_social_app/widgets/username_text.dart';

import '../../../constants/app_theme_constants.dart';
import '../../../models/post_content.dart';
import '../../../models/reaction.dart';
import '../../../services/post_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostEntry extends StatefulWidget {
  const PostEntry({Key? key, this.image, required this.post, this.padding})
      : super(key: key);

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
    _likeCount = widget.post.reactionCount;
    _isFavorite = (myReaction != null);
    _getAttachments();
    super.initState();
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

  Reaction? get myReaction => widget.post.myReaction;

  String? get mainCaption => widget.post.caption;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // padding: const EdgeInsets.all(10),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAvatar(
                  size: 40,
                  avt: '${widget.post.user!.avt}',
                  onTap: () {
                    ApplicationUtility.navigateToScreen(
                        context, ProfileScreen(userId: widget.post.user!.id!));
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UsernameText(username: widget.post.user!.username!),
                    Text(
                      // Jiffy(widget.post.createDate).fromNow(),
                      timeago.format(
                          DateTime.parse(widget.post.createDate.toString()),
                          locale: Localizations.localeOf(context).languageCode),
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          actions: [
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Are you sure delete this post?'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              context.read<PostBloc>().add(
                                                  RemovePost(widget.post.id!));
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop("Discard");
                                            },
                                            isDestructiveAction: true,
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('Cancel'),
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop("Cancel");
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Delete'))
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop("Cancel");
                            },
                            isDefaultAction: true,
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                          // title: const Text('duy nguyen posts'),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          //CAPTION
          mainCaption.toString().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8.0),
                  child: ExpandableText(
                    text: mainCaption.toString().trim(),
                    textStyle:
                        const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                )
              : const SizedBox.shrink(),
          PostAttachmentContainer(attachments: _attachments),
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     //CONTENTS
          //     (_attachments.isEmpty ||
          //             !_attachments.asMap().containsKey(_attachmentIndex))
          //         ? const SizedBox.shrink()
          //         : CachedNetworkImage(
          //             fit: BoxFit.fitWidth,
          //             imageUrl: imageUrl +
          //                 _attachments[_attachmentIndex].name.toString(),
          //             placeholder: (context, url) {
          //               return AspectRatio(
          //                 aspectRatio: 4 / 5,
          //                 child: Container(
          //                   color: Colors.grey.shade50,
          //                   child: const Center(
          //                     child: CupertinoActivityIndicator(),
          //                   ),
          //                 ),
          //               );
          //             },
          //             errorWidget: (context, url, error) =>
          //                 const SizedBox.shrink(),
          //           ),
          //     _attachments.length > 1
          //         ? Positioned(
          //             child: RoundedIconButton(
          //               onClick: () {
          //                 if (_attachmentIndex < getContents().length - 1) {
          //                   setState(() {
          //                     _attachmentIndex = _attachmentIndex + 1;
          //                   });
          //                 }
          //               },
          //               icon: Icons.arrow_forward_ios,
          //               iconColor: _attachmentIndex < 1
          //                   ? Colors.black12
          //                   : Colors.white,
          //               size: 20,
          //             ),
          //             right: 10,
          //           )
          //         : const SizedBox.shrink(),
          //     _attachments.length > 1
          //         ? Positioned(
          //             child: RoundedIconButton(
          //               onClick: () {
          //                 if (_attachmentIndex >= 1) {
          //                   setState(() {
          //                     _attachmentIndex = _attachmentIndex - 1;
          //                   });
          //                 }
          //               },
          //               icon: Icons.arrow_back_ios,
          //               iconColor: _attachmentIndex <= (_attachments.length - 1)
          //                   ? Colors.black12
          //                   : Colors.white,
          //               size: 20,
          //             ),
          //             left: 10,
          //           )
          //         : const SizedBox.shrink(),
          //     _attachments.length > 1
          //         ? Positioned(
          //             right: 10,
          //             top: 10,
          //             child: Container(
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 10, vertical: 5),
          //               decoration: BoxDecoration(
          //                 color: Colors.black87.withOpacity(.3),
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //               child: RichText(
          //                 text: TextSpan(children: [
          //                   TextSpan(text: '${_attachmentIndex + 1}'),
          //                   TextSpan(text: ' / ${_attachments.length}')
          //                 ], style: const TextStyle(color: Colors.white)),
          //               ),
          //             ),
          //           )
          //         : const SizedBox.shrink()
          //   ],
          // ),
          //BUTTONS
          Container(
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(.05),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: .1, color: Colors.grey.shade400),
                boxShadow: [
                  kDefaultPostActionBarShadow,
                ]),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  size: kDefaultBottomNavIconSize,
                                  Icons.favorite,
                                  color: Colors.red,
                                  key: ValueKey('icon1'),
                                )
                              : const Icon(
                                  size: kDefaultBottomNavIconSize,
                                  Icons.favorite_border,
                                  color: Colors.black45,
                                  key: ValueKey('icon2'),
                                ),
                        ),
                      ),
                      Text(_likeCount.toString()),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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
                        // icon: const Icon(
                        //   Icons.chat_bubble_outline,
                        //   color: Colors.black87,
                        // ),
                        icon: SvgPicture.asset(
                          'assets/icons/comment.svg',
                          width: kDefaultBottomNavIconSize,
                          height: kDefaultBottomNavIconSize,
                        ),
                      ),
                      Text(
                        widget.post.commentCount.toString(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/share.svg',
                          width: kDefaultBottomNavIconSize,
                          height: kDefaultBottomNavIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                context.read<PostBloc>().add(RemovePost(postId!));
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
