import 'package:flutter/material.dart';

import '../../../models/comment.dart';
import '../../../services/post_service.dart';
import '../../../widgets/expandable_text.dart';
import '../../../widgets/user_avt.dart';

class ReviewPostCommentEntry extends StatefulWidget {
  const ReviewPostCommentEntry({
    Key? key,
    this.level = 0,
    required this.commentContent,
    required this.commentId,
    this.userAvt,
    required this.onTap,
    required this.comment,
    this.currentReplyCommentId,
    required this.postService,
    this.currentFocusReplyId,
    this.replyCount = 0,
    this.removedCommentId,
  }) : super(key: key);
  final int level;
  final String commentContent;
  final int commentId;
  final String? userAvt;
  final Function onTap;
  final int? currentReplyCommentId;
  final Comment comment;
  final PostService postService;
  final int? currentFocusReplyId;
  final int? replyCount;
  final int? removedCommentId;

  @override
  State<ReviewPostCommentEntry> createState() => _ReviewPostCommentEntryState();
}

class _ReviewPostCommentEntryState extends State<ReviewPostCommentEntry> {
  final Set<Comment> _replyComments = {};

  @override
  void initState() {
    super.initState();
    if (widget.replyCount != null && widget.replyCount! > 0) {
      _getReplyComment();
    }
  }

  @override
  void didUpdateWidget(covariant ReviewPostCommentEntry oldWidget) {
    if (widget.removedCommentId == widget.commentId) {
      setState(() {
        _isRemoved = true;
      });
    }
    if ((
        // (widget.currentFocusReplyId == widget.commentId)
        // ||
        (oldWidget.currentReplyCommentId == widget.commentId))) {
      _getReplyComment();
    }

    super.didUpdateWidget(oldWidget);
  }

  _getReplyComment() async {
    var comments = await widget.postService
        .getReviewPostReplyComment(parentCommentId: widget.commentId);
    setState(() => _replyComments.addAll(comments));
  }

  int get level => widget.level;

  bool _isRemoved = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !_isRemoved
        ? Padding(
            // Padding level
            padding: level == 0
                ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: (level > 0)
                      ? EdgeInsets.only(
                          left: level <= 3 ? level * 25 : 4 * 25,
                          top: 10,
                        )
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
                            onTap: () {},
                            size: 30,
                            avt: widget.userAvt,
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
                                    widget.onTap(widget.comment);
                                  },
                                  //COMMENT TEXT
                                  child: Ink(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: widget.level >= 2
                                            ? size.width * .4
                                            : size.width * .6,
                                        // minWidth: 200,
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.comment.user?.username}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueAccent),
                                          ),
                                          ExpandableText(
                                              text:
                                                  '\t${widget.commentId}\t${widget.commentContent}',
                                              textStyle: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              textColor: Colors.black87),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // GestureDetector(
                                  // child: Text('level ${widget.level}'),
                                  // onTap: () {
                                  // },
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ..._replyComments.map(
                  (e) => ReviewPostCommentEntry(
                    currentFocusReplyId: widget.currentReplyCommentId,
                    commentContent: e.content!,
                    currentReplyCommentId: widget.currentReplyCommentId,
                    commentId: e.id!,
                    removedCommentId:
                        _isRemoved ? e.id : widget.removedCommentId,
                    onTap: (e) => widget.onTap(e),
                    level: (widget.level + 1),
                    userAvt: e.user?.avt,
                    comment: e,
                    postService: widget.postService,
                    replyCount: e.replyCount,
                  ),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
