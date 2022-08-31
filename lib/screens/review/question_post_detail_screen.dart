import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:traveling_social_app/models/question_post.dart';
import 'package:traveling_social_app/services/post_service.dart';

import '../../constants/app_theme_constants.dart';
import '../../models/comment.dart';
import '../../services/comment_service.dart';
import '../../widgets/comment_input_reply_widget.dart';
import '../../widgets/user_avt.dart';
import 'components/review_post_comment_section.dart';

class QuestionPostDetailScreen extends StatefulWidget {
  const QuestionPostDetailScreen({Key? key, required this.questionPostId})
      : super(key: key);
  final int questionPostId;

  @override
  State<QuestionPostDetailScreen> createState() =>
      _QuestionPostDetailScreenState();

  static Route route(int questionPostId) => MaterialPageRoute(
        builder: (context) =>
            QuestionPostDetailScreen(questionPostId: questionPostId),
      );
}

class _QuestionPostDetailScreenState extends State<QuestionPostDetailScreen> {
  final _postService = PostService();
  final _commentService = CommentService();
  QuestionPost? _questionPost;
  Set<Comment> _comments = {};
  final _commentController = TextEditingController();
  bool _isBlockComment = true;

  @override
  void initState() {
    super.initState();
    _postService
        .getQuestionPostDetail(questionPostId: widget.questionPostId)
        .then((value) {
      setState(() {
        _questionPost = value;
        if (value != null && !value.isClose) {
          _isBlockComment = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                ),
              ),
              leadingWidth: 25,
              pinned: true,
              centerTitle: false,
              title: _questionPost == null
                  ? const SizedBox.shrink()
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvatar(
                              size: 40,
                              avt: '${_questionPost!.user?.avt}',
                              onTap: () {}),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _questionPost!.user!.username!,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                                Text(
                                  timeago.format(
                                      DateTime.parse(
                                          _questionPost!.createDate.toString()),
                                      locale: Localizations.localeOf(context)
                                          .languageCode),
                                  style: const TextStyle(
                                      color: Colors.black26, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              elevation: 0,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey.shade200,
                    height: 1.0,
                  ),
                  preferredSize: const Size.fromHeight(1)),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.black38,
                )
              ],
            )
          ];
        },
        body: Stack(
          children: [
            _questionPost != null
                ? ListView(
                    padding: EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    children: [
                      Text(
                        _questionPost!.caption.toString(),
                        style: TextStyle(color: Colors.black87, fontSize: 18),
                      ),
                      _questionPost!.isClose
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '${_questionPost!.user?.username} đã đóng thảo luận trên bài này!',
                                style: TextStyle(
                                    color: Colors.redAccent.shade100,
                                    fontSize: 14),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.comment,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                      ReviewPostCommentSection(
                        currentFocusReplyId: _currentFocusReplyId,
                        postId: _questionPost!.id!,
                        currentReplyId: _replyComment?.id,
                        comments: _comments,
                        setReplyComment: (e) {
                          setState(() => _replyComment = e);
                        },
                        hideComment: (id) async {
                          await _commentService.hideComment(commentId: id);
                        },
                        setRemoveCommentId: (id) {
                          if (id == null) {
                            setState(() {
                              _removedCommentId = null;
                            });
                            return;
                          }
                          setState(() {
                            _removedCommentId = id;
                          });
                        },
                        removedCommentId: _removedCommentId,
                        getComments: () async {
                          final resp =
                              await _commentService.getRootCommentsOnPost(
                                  postId: _questionPost!.id!);
                          setState(() => _comments = {...resp});
                        },
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            Visibility(
              visible: _questionPost == null,
              child: const Positioned.fill(
                  child: Center(
                child: CupertinoActivityIndicator(),
              )),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: !_isBlockComment,
                child: CommentInputReplyWidget(
                  message: _replyComment?.content,
                  onClose: () {
                    setState(() => _replyComment = null);
                  },
                  showReplyUser: _replyComment != null,
                  replyUsername: _replyComment != null
                      ? _replyComment!.user?.username
                      : null,
                  onChange: (text) {},
                  sendBtnColor: kPrimaryLightColor,
                  controller: _commentController,
                  onSendButtonClick: _uploadComment,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Comment? _replyComment;
  int? _currentFocusReplyId;
  int? _removedCommentId;

  _uploadComment() async {
    var text = _commentController.text;
    if (text.isEmpty) return;
    try {
      Comment comment = await _commentService.commentPost(
          postId: _questionPost!.id!,
          contentText: text.toString(),
          parentCommentId: _replyComment?.id);
      if (_replyComment?.id != null) {
        print('add to child');
        setState(() {
          _currentFocusReplyId = _replyComment!.id!;
        });
      } else {
        print('add to level 0');
        setState(() {
          _comments.add(comment);
        });
      }
      setState(() {
        _replyComment = null;
        _removedCommentId = null;
      });
    } on Exception catch (e) {
      print(e);
    } finally {
      _commentController.text = lorem(words: 6, paragraphs: 1);
    }
  }
}
