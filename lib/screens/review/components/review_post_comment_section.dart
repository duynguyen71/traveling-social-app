import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/screens/review/components/review_post_comment_entry.dart';
import '../../../authentication/bloc/authentication_bloc.dart';
import '../../../services/post_service.dart';
import '../../../utilities/application_utility.dart';
import '../../../widgets/bottom_select_dialog.dart';
import 'package:provider/provider.dart';

class ReviewPostCommentSection extends StatefulWidget {
  const ReviewPostCommentSection({
    Key? key,
    required this.postId,
    required this.comments,
    required this.getComments,
    required this.setReplyComment,
    this.currentReplyId,
    this.currentFocusReplyId,
    required this.hideComment,
    this.removedCommentId,
    required this.setRemoveCommentId,
  }) : super(key: key);

  @override
  State<ReviewPostCommentSection> createState() =>
      _ReviewPostCommentSectionState();

  final int postId;
  final Set<Comment> comments;
  final Function getComments;
  final Function setReplyComment;
  final int? currentReplyId;
  final Function hideComment;
  final int? currentFocusReplyId;
  final int? removedCommentId;
  final Function setRemoveCommentId;
}

class _ReviewPostCommentSectionState extends State<ReviewPostCommentSection> {
  final _postService = PostService();

  @override
  void initState() {
    widget.getComments();
    super.initState();
  }

  Set<Comment> get comments => widget.comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var comment = comments.elementAt(index);
            return ReviewPostCommentEntry(
              postService: _postService,
              currentReplyCommentId: widget.currentReplyId,
              comment: comment,
              commentContent: comment.content!,
              commentId: comment.id!,
              userAvt: comment.user?.avt,
              currentFocusReplyId: widget.currentFocusReplyId,
              removedCommentId: widget.removedCommentId,
              replyCount: comment.replyCount,
              level: 0,
              onTap: (c) => showDialog(c),
            );
          },
          itemCount: comments.length,
        ),
      ),
    );
  }

  void showDialog(Comment comment) {
    ApplicationUtility.showModelBottomDialog(
      context,
      comment.user!.id! != context.read<AuthenticationBloc>().state.user.id
          ? MyBottomDialog(
              items: [
                //REPLY COMMENT BUTTON
                BottomDialogItem(
                    title: 'Reply',
                    onClick: () {
                      widget.setReplyComment(comment);
                      widget.setRemoveCommentId(null);
                    }),
                BottomDialogItem(
                  title: 'Copy',
                  onClick: () {
                    Clipboard.setData(
                        ClipboardData(text: comment.content.toString()));
                  },
                ),
              ],
            )
          : MyBottomDialog(
              items: [
                BottomDialogItem(
                    title: 'Hide',
                    onClick: () {
                      // widget.hideComment(comment.id);
                      widget.setRemoveCommentId(comment.id);
                    }),
                BottomDialogItem(
                  title: 'Copy',
                  onClick: () {
                    Clipboard.setData(
                        ClipboardData(text: comment.content.toString()));
                  },
                ),
              ],
            ),
    );
  }
}
