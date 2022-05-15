import 'package:flutter/material.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:provider/provider.dart';
import '../models/Comment.dart';
import 'package:flutter/services.dart';

import '../models/User.dart';
import '../services/comment_service.dart';
import 'package:provider/provider.dart';

class CommentEntry extends StatefulWidget {
  const CommentEntry({
    Key? key,
    required this.comment,
    required this.level,
    // required this.controller,
    required this.postId,
    required this.setReplyingComment,
    // required this.focusNode,
    // this.replyingComment,
    // required this.setReplyComment,
    // required this.onClickCallback,
  }) : super(key: key);

  final Comment comment;
  final int level;

  // final TextEditingController controller;
  final int postId;

  // final FocusNode focusNode;
  // final Comment? replyingComment;
  // final Function setReplyComment;

  // final Function onClickCallback;

  // final Function replyComment;
  final Function setReplyingComment;

  @override
  State<CommentEntry> createState() => _CommentEntryState();
}

class _CommentEntryState extends State<CommentEntry> {
  final CommentService _commentService = CommentService();
  final Set<Comment> _childrenComment = <Comment>{};
  final FocusNode inputNode = FocusNode();
  final GlobalKey<_CommentEntryState> _myKey = GlobalKey();

  _getReplyComments() async {
    List<Comment> rs =
        await _commentService.getReplyComment(parentCommentId: comment.id!);
    setState(() {
      _childrenComment.addAll(rs);
    });
  }

  Comment get comment => widget.comment;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: (widget.level <= 3 && widget.level > 0)
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
                size: 30,
                user:
                    widget.comment.user ?? context.read<UserViewModel>().user!,
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
                          BottomSelectDialog(
                            items: [
                              //REPLY COMMENT BUTTON
                              SelectItem(
                                  title: 'Reply',
                                  onClick: () {
                                    widget.setReplyingComment(widget.comment);
                                    // widget.setReplyComment(widget.comment);
                                    // widget.comment;
                                    //     widget.onClickCallback(widget.comment);
                                    // Comment commetn = Comment(
                                    //     id: DateTime.now()
                                    //         .millisecondsSinceEpoch,
                                    //     content: 'sd' + 'callback',
                                    //     createDate: null);
                                    // setState(() {
                                    //   _childrenComment.add(commetn);
                                    // });
                                    // print('rep');
                                  }),
                              SelectItem(
                                title: 'Copy',
                                onClick: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.comment.content.toString()));
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
                              color: Colors.grey.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: ExpandableText(
                              text: widget.comment.content.toString(),
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
                        Text('Like'),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          child: Text('Answer'),
                          onTap: () {
                            // String rep =
                            //     await
                            // widget.onClickCallback(widget.comment);
                            Comment commetn = Comment(
                                id: DateTime.now().millisecondsSinceEpoch,
                                content: 'sd' + 'callback',
                                createDate: null);
                            setState(() {
                              _childrenComment.add(commetn);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  (comment.replyCount != null &&
                          comment.replyCount! > 0 &&
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
                                  style: const TextStyle(color: Colors.black54),
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
              key:ValueKey(e.id.toString()),
              postId: widget.postId,
              setReplyingComment: widget.setReplyingComment,
              // focusNode: widget.focusNode,
              // replyingComment: e,
              // setReplyComment: widget.setReplyComment,
              comment: e,
              level: (widget.level + 1),
              // controller: widget.controller,
              // onClickCallback: (e) async => await widget.onClickCallback(e),
            ),
          ),
          // ...widget.children
        ],
      ),
    );
  }
}
typedef void MyCallback(int foo);