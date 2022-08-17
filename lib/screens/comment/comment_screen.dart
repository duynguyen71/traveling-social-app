import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:traveling_social_app/bloc/post/post_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/services/comment_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/comment_input_reply_widget.dart';
import '../../models/comment.dart';
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

class _CommentScreenState extends State<CommentScreen>
    with AutomaticKeepAliveClientMixin {
  final CommentService _commentService = CommentService();

  final Set<Comment> _comments = <Comment>{};
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  List<Comment> get myComments => widget.myComments;
  final TextEditingController _commentController = TextEditingController();
  Comment? _currentReplyComment;
  Comment? _currentFocusReplyComment;
  Comment? _currentFocusEditComment;
  String? editedMessage;

  _sendComment() async {
    int? parentCommentId;
    if (_currentFocusReplyComment != null) {
      parentCommentId = _currentFocusReplyComment!.id;
    }
    try {
      isLoading = true;
      var commentText = _commentController.text;
      if (commentText.toString().isNotEmpty) {
        final commentResp = await _commentService.commentPost(
            postId: widget.postId,
            commentId: null,
            contentText: commentText.toString().trim(),
            parentCommentId: parentCommentId);
        if (_currentFocusReplyComment != null) {
          setState(() {
            _currentReplyComment = _currentFocusReplyComment;
          });
        } else {
          setState(() {
            _comments.add(commentResp);
          });
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 80);
        }
        context.read<PostBloc>().add(IncrementCommentCount(widget.postId));
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    } finally {
      ApplicationUtility.hideKeyboard();
      _commentController.clear();
      isLoading = false;
    }
    setState(() {
      _currentFocusReplyComment = null;
      _currentFocusReplyComment = null;
    });
  }

  updateComment() {
    if (_currentFocusEditComment != null) {
      Comment temp = _currentFocusEditComment!;
      temp.content = _commentController.text.toString();
    }
    _currentFocusEditComment = null;
    _commentController.clear();
    ApplicationUtility.hideKeyboard();
  }

  hideComment(c) async {
    context.read<PostBloc>().add(RemoveComment(widget.postId, c.id));
  }

  replyCommentRequest(Comment c) {
    _currentFocusReplyComment = c;
    _focusNode.requestFocus();
  }

  editCommentRequest(Comment c) {
    _currentFocusEditComment = c;
    _commentController.text = c.content.toString();
    _focusNode.requestFocus();
  }

  Comment? _editedComment;

  @override
  void initState() {
    //get current user comments
    if (myComments.isNotEmpty) {
      setState(() {
        _comments.addAll(Set.from(myComments));
      });
    }
    //get comments
    _getOtherUserComments();
    _commentController.text =
        DateTime.now().millisecond.toString() + " comment";
    _scrollController.addListener(() async {
      var pixels2 = _scrollController.position.pixels;
      var maxScrollExtent2 = _scrollController.position.maxScrollExtent;
      if ((maxScrollExtent2 - pixels2) <=
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .size
                  .height *
              .3) {
      }
    });
    super.initState();
    _commentController.text = lorem(words: 12,paragraphs: 1);
  }

  _getOtherUserComments() async {
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
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.withOpacity(.1),
      body: Container(
        height: size.height,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSpace(),
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
                      controller: _scrollController,
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
                            //RENDER COMMENT TREE
                            ...List.generate(
                              _comments.length + 1,
                              (index) {
                                if (index == _comments.length) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: _isLoading
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : const SizedBox.shrink(),
                                  );
                                }
                                var c = _comments.elementAt(index);
                                return CommentEntry(
                                  hideComment: (c) => hideComment(c),
                                  comment: c,
                                  postId: widget.postId,
                                  level: 0,
                                  isShowChildren:
                                      // (_currentReplyComment != null &&
                                      //     _currentReplyComment!.id == c.id),
                                      true,
                                  currentReplyComment: _currentReplyComment,
                                  key: ValueKey(c.id.toString()),
                                  replyCommentRequest: (c) =>
                                      replyCommentRequest(c),
                                  editCommentRequest: (c) =>
                                      editCommentRequest(c),
                                  editedComment: (_editedComment != null &&
                                          _editedComment!.id == c.id)
                                      ? _editedComment
                                      : null,
                                  userId: c.user?.id,
                                  avt: c.user?.avt,
                                  username: c.user?.username,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    //
                    Positioned(
                      child: CommentInputReplyWidget(
                        message: _currentFocusReplyComment != null
                            ? _currentFocusReplyComment!.content.toString()
                            : '',
                        onClose: () {
                          ApplicationUtility.hideKeyboard();
                          setState(() {
                            _currentFocusReplyComment = null;
                            _currentReplyComment = null;
                          });
                        },
                        showReplyUser: _currentFocusReplyComment != null,
                        replyUsername: (_currentFocusReplyComment != null &&
                                _currentFocusReplyComment!.user != null)
                            ? _currentFocusReplyComment!.user!.username
                            : null,
                        onChange: (text) {},
                        sendBtnColor: kPrimaryLightColor,
                        controller: _commentController,
                        focusNode: _focusNode,
                        onSendButtonClick: () {
                          _sendComment();
                        },
                      ),
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpace() {
    return Expanded(
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
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
