import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import '../models/Comment.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';
import '../services/comment_service.dart';

class CommentEntry extends StatefulWidget {
  const CommentEntry({
    Key? key,
    required this.comment,
    required this.level,
    required this.postId,
    required this.isShowChildren,
    required this.replyCommentRequest,
    this.currentReplyComment,
    required this.hideComment,
    required this.editCommentRequest,
    this.editedComment,
  }) : super(key: key);

  final Comment comment;
  final int level;
  final int postId;
  final bool isShowChildren;

  final Comment? currentReplyComment;
  final Function replyCommentRequest;

  final Function editCommentRequest;
  final Function hideComment;

  final Comment? editedComment;

  @override
  State<CommentEntry> createState() => _CommentEntryState();
}

class _CommentEntryState extends State<CommentEntry> {
  final CommentService _commentService = CommentService();
  final Set<Comment> _childrenComment = <Comment>{};

  bool _hiding = false;

  _getReplyComments() async {
    List<Comment> rs = await _commentService.getReplyComment(
        parentCommentId: widget.comment.id!);
    setState(() {
      _childrenComment.addAll(rs);
    });
  }

  Comment get comment => widget.comment;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CommentEntry oldWidget) {
    if (widget.isShowChildren &&
        (widget.currentReplyComment != null &&
            widget.currentReplyComment!.id == comment.id)) {
      _getReplyComments();
    }
    super.didUpdateWidget(oldWidget);
  }

  int get level => widget.level;

  User? get user => widget.comment.user;

  User? get currentUser=> context.read<UserViewModel>().user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _hiding
        ? const SizedBox.shrink()
        : Padding(
            padding: level == 0
                ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10)
                : EdgeInsets.zero,
            child: Padding(
              padding: (level <= 3 && level > 0)
                  ? const EdgeInsets.only(left: 40, top: 5)
                  : EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //USER AVT
                      UserAvatar(
                        onTap: () {
                          ApplicationUtility.navigateToScreen(
                              context,
                              context.read<UserViewModel>().equal(widget.comment.user)
                                  ? const CurrentUserProfileScreen()
                                  : ProfileScreen(userId: widget.comment.user!.id!));
                        },
                        size: 30,
                        user: widget.comment.user != null
                            ? widget.comment.user!
                            : context.read<UserViewModel>().user!,
                        margin: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                ApplicationUtility.showModelBottomDialog(
                                  context,
                                  (user != null) &&
                                          (user!.id !=
                                              context
                                                  .read<UserViewModel>()
                                                  .user!
                                                  .id)
                                      ? BottomSelectDialog(
                                          items: [
                                            //REPLY COMMENT BUTTON
                                            SelectItem(
                                                title: 'Reply',
                                                onClick: () {
                                                  widget.replyCommentRequest(
                                                      widget.comment);
                                                }),
                                            SelectItem(
                                              title: 'Copy',
                                              onClick: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: widget.comment.content
                                                        .toString()));
                                              },
                                            ),
                                          ],
                                        )
                                      : BottomSelectDialog(
                                          items: [
                                            // SelectItem(
                                            //     title: 'Edit',
                                            //     onClick: () {
                                            //       widget.editCommentRequest(
                                            //           widget.comment);
                                            //     }),
                                            SelectItem(
                                                title: 'Hide',
                                                onClick: () {
                                                  widget.hideComment(
                                                      widget.comment);
                                                  setState(() {
                                                    _hiding = true;
                                                  });
                                                }),
                                            SelectItem(
                                              title: 'Copy',
                                              onClick: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: widget.comment.content
                                                        .toString()));
                                              },
                                            ),
                                          ],
                                        ),
                                );
                              },
                              //COMMENT TEXT
                              child: Ink(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: widget.level >= 2
                                        ? size.width * .5
                                        : size.width * .7,
                                    minWidth: size.width * .5,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ExpandableText(
                                      text: widget.comment.content.toString(),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textColor: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Like'),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: const Text('Answer'),
                                  onTap: () => widget
                                      .replyCommentRequest(widget.comment),
                                )
                              ],
                            ),
                          ),
                          (widget.comment.replyCount != null &&
                                  widget.comment.replyCount! > 0 &&
                                  _childrenComment.isEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await _getReplyComments();
                                      },
                                      child: Ink(
                                        child: Text(
                                          'View all ${widget.comment.replyCount} reply',
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                  ..._childrenComment.map(
                    (e) => CommentEntry(
                      isShowChildren: (widget.currentReplyComment != null &&
                          widget.currentReplyComment!.id == e.id),
                      key: ValueKey(e.id.toString()),
                      postId: widget.postId,
                      replyCommentRequest: (e) => widget.replyCommentRequest(e),
                      currentReplyComment: widget.currentReplyComment,
                      comment: e,
                      level: (widget.level + 1),
                      hideComment: (e) => widget.hideComment(e),
                      editCommentRequest: (e) => widget.editCommentRequest(e),
                      editedComment: widget.editedComment != null &&
                              widget.editedComment!.id == e.id
                          ? widget.editedComment
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
