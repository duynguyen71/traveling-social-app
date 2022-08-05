import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/screens/profile/current_user_profile_screen.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import '../models/comment.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    required this.userId,
    required this.username,
    required this.avt,
  }) : super(key: key);

  final Comment comment;
  final int level;
  final int postId;
  final bool isShowChildren;

  final Comment? currentReplyComment;
  final Function replyCommentRequest;

  final Function editCommentRequest;
  final Function hideComment;

  final int userId;
  final String username;
  final String avt;

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
    if (widget.level <= 3) {
      _getReplyComments();
    }
  }

  @override
  void didUpdateWidget(covariant CommentEntry oldWidget) {
    if (widget.isShowChildren &&
        (widget.currentReplyComment != null &&
            widget.currentReplyComment!.id == comment.id)) {
      print('did update widget ${widget.comment.id}');
      _getReplyComments();
    }
    super.didUpdateWidget(oldWidget);
  }

  int get level => widget.level;

  // User? get user => widget.comment.user;

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
                              context
                                      .read<UserViewModel>()
                                      .equal(widget.comment.user)
                                  ? const CurrentUserProfileScreen()
                                  : ProfileScreen(
                                      userId: widget.comment.user!.id!));
                        },
                        size: 30,
                        avt: widget.comment.user != null
                            ? widget.comment.user!.avt.toString()
                            : context
                                .read<AuthenticationBloc>()
                                .state
                                .user
                                .avt
                                .toString(),
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
                                  widget.userId !=
                                          context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user
                                              .id
                                      ? MyBottomDialog(
                                          items: [
                                            //REPLY COMMENT BUTTON
                                            BottomDialogItem(
                                                title: 'Reply',
                                                onClick: () {
                                                  widget.replyCommentRequest(
                                                      widget.comment);
                                                }),
                                            BottomDialogItem(
                                              title: 'Copy',
                                              onClick: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: widget.comment.content
                                                        .toString()));
                                              },
                                            ),
                                          ],
                                        )
                                      : MyBottomDialog(
                                          items: [
                                            // SelectItem(
                                            //     title: 'Edit',
                                            //     onClick: () {
                                            //       widget.editCommentRequest(
                                            //           widget.comment);
                                            //     }),
                                            BottomDialogItem(
                                                title: 'Hide',
                                                onClick: () {
                                                  widget.hideComment(
                                                      widget.comment);
                                                  setState(() {
                                                    _hiding = true;
                                                  });
                                                }),
                                            BottomDialogItem(
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
                      isShowChildren: true,
                      // (widget.currentReplyComment != null &&
                      //     widget.currentReplyComment!.id == e.id),
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
                      userId: widget.userId,
                      username: widget.username,
                      avt: widget.avt,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
