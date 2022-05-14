import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/services/comment_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/comment_input_widget.dart';

import '../../models/Comment.dart';
import '../../models/User.dart';
import '../../widgets/comment_entry.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {Key? key, required this.postId, this.myComments = const []})
      : super(key: key);
  final int postId;
  final List<Comment> myComments;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentService _commentService = CommentService();

  final Set<Comment> _comments = <Comment>{};
  final FocusNode inputNode = FocusNode();

  bool _isLoading = false;

  Comment? _replyingComment;

  List<Comment> get myComments => widget.myComments;

  final TextEditingController _commentController = TextEditingController();

  _sendComment() async {
    try {
      isLoading = true;
      var commentText = _commentController.text;
      if (commentText.toString().isNotEmpty) {
        final commentResp = await _commentService.commentPost(
            postId: widget.postId,
            commentId: null,
            contentText: commentText.toString().trim(),
            parentCommentId: null);
        setState(() {
          _comments.add(commentResp);
        });
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    } finally {
      ApplicationUtility.hideKeyboard();
      _commentController.clear();
      isLoading = false;
    }
  }

  _replyCommentRequest(Comment c) async {
    FocusScope.of(context).requestFocus(inputNode);
    if (c.user != null) {
      _commentController.text = '@${c.user!.username.toString()} ';
    } else {
      _commentController.text =
          '@${context.read<UserViewModel>().user!.username.toString()} ';
    }
    _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length));
    _replyingComment = c;
    print('reply to comment : ' + c.content.toString());
  }

  _sendReplyingComment() async {
    try {
      isLoading = true;
      var commentText = _commentController.text;
      if (commentText.toString().isNotEmpty) {
        final commentResp = await _commentService.commentPost(
            postId: widget.postId,
            commentId: null,
            contentText: commentText.toString().trim(),
            parentCommentId: null);
        setState(() {
          _comments.add(commentResp);
        });
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    } finally {
      ApplicationUtility.hideKeyboard();
      isLoading = false;
      _replyingComment = null;
      _commentController.clear();
    }
  }

  bool _isReplying() {
    if (_replyingComment == null) {
      _replyingComment = null;
      return false;
    }
    User? replyUser = _replyingComment!.user;
    if (replyUser == null) {
      return false;
    }
    String trim = _commentController.text
        .substring(1, (replyUser.username.toString().length + 1));
    if (trim != replyUser.username) {
      _replyingComment = null;
      return false;
    }
    return true;
  }

  @override
  void initState() {
    //get current user comments
    if (myComments.isNotEmpty) {
      setState(() {
        _comments.addAll(Set.from(myComments));
      });
    }
    //get comments
    _getComments();
    _commentController.text =
        DateTime.now().millisecond.toString() + " comment";
    super.initState();
  }

  _getComments() async {
    isLoading = true;
    var comments =
        await _commentService.getRootCommentsOnPost(postId: widget.postId);
    setState(() {
      _comments.addAll(Set.from(comments));
    });
    isLoading = false;
  }

  set isLoading(bool l) {
    setState(() {
      _isLoading = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.withOpacity(.1),
        body: Container(
          height: size.height,
          // alignment: Alignment.bottomCenter,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.withOpacity(.1),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  height: size.height - 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Comments",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              ...List.generate(
                                _comments.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10),
                                  child: CommentEntry(
                                    comment: _comments.elementAt(index),
                                    key:
                                        ValueKey(_comments.elementAt(index).id),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //
                      Positioned(
                        child: CommentInputWidget(
                          focusNode: inputNode,
                          onSendButtonClick: () => _sendComment(),
                          placeHolderText: 'Write your comment',
                          controller: _commentController,
                        ),
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      _isLoading
                          ? const Positioned.fill(
                              child:
                                  Center(child: CupertinoActivityIndicator()))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
