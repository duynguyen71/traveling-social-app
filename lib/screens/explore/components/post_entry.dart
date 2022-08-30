import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/models/attachment.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/screens/comment/comment_screen.dart';
import 'package:traveling_social_app/screens/explore/components/post_attachment_container.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:traveling_social_app/widgets/username_text.dart';

import '../../../models/post_content.dart';
import '../../../models/reaction.dart';
import '../../../services/post_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostEntry extends StatefulWidget {
  const PostEntry(
      {Key? key,
      this.image,
      required this.post,
      this.padding,
      this.onTapMoreIcon})
      : super(key: key);

  final String? image;
  final Post post;
  final Padding? padding;
  final Function()? onTapMoreIcon;

  @override
  State<PostEntry> createState() => _PostEntryState();
}

class _PostEntryState extends State<PostEntry>
    with AutomaticKeepAliveClientMixin {
  bool _isFavorite = false;
  final PostService _postService = PostService();
  final List<Attachment> _attachments = [];

  int _likeCount = 0;

  @override
  void initState() {
    super.initState();

    _getAttachments();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _likeCount = widget.post.reactionCount;
      _isFavorite = (myReaction != null);
    });
    super.didChangeDependencies();
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER AVT AVT
          Container(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAvatar(
                  size: 40,
                  avt: '${widget.post.user!.avt}',
                  onTap: () {
                    context.read<AuthenticationBloc>().state.user.id ==
                            widget.post.user?.id
                        ? () {}
                        : ApplicationUtility.navigateToScreen(context,
                            ProfileScreen(userId: widget.post.user!.id!));
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UsernameText(username: widget.post.user!.username!),
                    Text(
                      timeago.format(
                          DateTime.parse(widget.post.createDate.toString()),
                          locale: Localizations.localeOf(context).languageCode),
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                // ICON MORE
                IconButton(
                  onPressed: widget.onTapMoreIcon,
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          //CAPTION
          mainCaption.toString().isEmpty
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 4))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: ExpandableText(
                    text: '${mainCaption?.trim()}',
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
          PostAttachmentContainer(attachments: _attachments),
          //BUTTONS
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.05),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(width: .1, color: Colors.grey.shade400),
            ),
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
                              ? Icon(
                                  size: 24.0,
                                  Icons.favorite,
                                  color: Colors.red,
                                  key: ValueKey('icon1'),
                                )
                              : Icon(
                                  size: 24.0,
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
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CommentScreen(
                                  postId: widget.post.id!,
                                  myComments: widget.post.myComments,
                                );
                              },
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              isDismissible: true);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/comment.svg',
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                      Text(
                        '${widget.post.commentCount}',
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     mainAxisSize: MainAxisSize.max,
                //     children: [
                //       IconButton(
                //         onPressed: () {},
                //         icon: SvgPicture.asset(
                //           'assets/icons/share.svg',
                //           width: 24.0,
                //           height: 24.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int? get postId => widget.post.id;

  @override
  bool get wantKeepAlive => true;
}
