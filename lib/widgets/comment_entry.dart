import 'package:flutter/material.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:provider/provider.dart';
import '../models/Comment.dart';
import 'package:flutter/services.dart';

import '../services/comment_service.dart';

class CommentEntry extends StatefulWidget {
  const CommentEntry({Key? key, required this.comment, this.level})
      : super(key: key);

  final Comment comment;
  final int? level;

  // final Function replyComment;

  @override
  State<CommentEntry> createState() => _CommentEntryState();
}

class _CommentEntryState extends State<CommentEntry> {
  final CommentService _commentService = CommentService();

  final Set<Comment> _childrenComment = <Comment>{};

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
      padding: widget.level != null
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
                  //CONTENT
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ApplicationUtility.showModelBottomDialog(
                          context,
                          BottomSelectDialog(
                            items: [
                              SelectItem(title: 'Reply', onClick: () {}),
                              SelectItem(
                                  title: 'Copy',
                                  onClick: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            widget.comment.content.toString()));
                                  },),
                            ],
                          ),
                        );
                      },
                      //COMMENT TEXT
                      child: Ink(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width * .7,
                            minWidth: 200,
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
                      children: const [
                        Text('Like'),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Answer')
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
              comment: e,
              level: 1,
            ),
          ),
        ],
      ),
    );
  }
}
