import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/screens/review/components/review_post_att_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/widgets/comment_input_reply_widget.dart';
import '../../constants/api_constants.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/base_user.dart';
import '../../models/review_post_details.dart';
import '../../services/post_service.dart';
import '../../widgets/user_avt.dart';
import '../create_review/components/cover_image_container.dart';
import '../create_review/components/review_post_title.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'components/auth_tag.dart';
import 'components/reaction_bar.dart';
import 'components/review_post_comment_section.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewPostDetailScreen extends StatefulWidget {
  const ReviewPostDetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ReviewPostDetailScreen> createState() => _ReviewPostDetailScreenState();

  static Route route(int id) =>
      MaterialPageRoute(builder: (_) => ReviewPostDetailScreen(id: id));
}

class _ReviewPostDetailScreenState extends State<ReviewPostDetailScreen> {
  final _postService = PostService();
  bool _isFetching = true;
  late ReviewPostDetails _reviewPostDetail;
  late quill.QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();
  final _commentController = TextEditingController();
  Set<Comment> _comments = {};

  _getReviewPostDetail() async {
    var data = await _postService.getReviewPostDetail(id);
    if (data != null) {
      _quillController = quill.QuillController(
          document: quill.Document.fromJson(jsonDecode(data.contentJson!)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {
        _reviewPostDetail = data;
        _isFetching = false;
      });
    }
  }

  int get id => widget.id;

  @override
  void initState() {
    _getReviewPostDetail();
    super.initState();
    _commentController.text = lorem(paragraphs: 1, words: 12);
  }

  final _scrollController = ScrollController();

  BaseUserInfo get author => _reviewPostDetail.user!;

  Comment? _replyComment;

  int? _currentFocusReplyId;
  int? _removedCommentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        // dragStartBehavior: DragSta,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView(
                physics: const BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                // keyboardDismissBehavior:
                // ScrollViewKeyboardDismissBehavior.,
                shrinkWrap: false,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  _isFetching
                      ? const SizedBox(
                          height: 1000,
                        )
                      : const SizedBox.shrink(),
                  // POST TITLE
                  _isFetching
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child:
                              ReviewPostTitle(title: _reviewPostDetail.title!),
                        ),
                  // POST COVER IMAGE
                  _isFetching
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CoverImageContainer(
                            child: Container(
                              color: Colors.grey.shade200,
                              child: ClipRRect(
                                borderRadius: kReviewPostBorderRadius,
                                child: CachedNetworkImage(
                                  alignment: Alignment.center,
                                  imageUrl:
                                      '$imageUrl${_reviewPostDetail.coverImage!.name}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                  // QUILL CONTROLLER
                  _isFetching
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: quill.QuillEditor(
                            controller: _quillController,
                            readOnly: true,
                            scrollable: false,
                            scrollController: _scrollController,
                            focusNode: _focusNode,
                            autoFocus: false,
                            expands: false,
                            padding: EdgeInsets.zero,
                            showCursor: false, // add th
                          ),
                        ),
                  //
                  (_isFetching || _reviewPostDetail.images.isEmpty)
                      ? const SizedBox.shrink()
                      : Container(
                          height: kReviewPostMinHeight,
                          constraints: const BoxConstraints(
                              minHeight: kReviewPostMinHeight),
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _showAttScrollView(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius:
                                          kReviewPostImageGalleryBorder,
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '$imageUrl${_reviewPostDetail.images[index].image!.name}'),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _reviewPostDetail.images.length,
                            shrinkWrap: true,
                          )),
                  _isFetching ? const SizedBox.shrink() : AuthTag(auth: author),
                  _isFetching
                      ? const SizedBox.shrink()
                      : ReactionBar(
                          onLike: () {},
                          onComment: () {
                            setState(() {
                              _commentFocusNode.requestFocus();
                            });
                          },
                          onShare: () {},
                        ),
                  _isFetching
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ReviewPostCommentSection(
                            currentFocusReplyId: _currentFocusReplyId,
                            postId: _reviewPostDetail.id!,
                            //TODO: cajjjjj
                            currentReplyId: _replyComment?.id,
                            comments: _comments,
                            // setComments: (comments) =>
                            //     setState(() => _comments = comments),
                            setReplyComment: (e) {
                              print('set reply comment $e');
                              setState(() => _replyComment = e);
                            },
                            hideComment: (id) {},
                            setRemoveCommentId: (id) {
                              if(id==null){
                                setState(() {
                                  _removedCommentId = null;
                                });
                                return;
                              }
                              print('removed comment $id');
                              try {
                                _postService.hideReviewPostComment(
                                    commentId: id);
                                setState(() {
                                  _removedCommentId = id;
                                });
                                // _removedCommentId = null;
                              } on Exception {}
                            },
                            removedCommentId: _removedCommentId,
                            getComments: () async {
                              final resp =
                                  await _postService.getReviewPostComments(
                                      postId: _reviewPostDetail.id!);
                              setState(() => _comments = resp);
                            },
                          ),
                        ),
                  // SPACER
                  const SizedBox(
                    height: 100,
                  ),
                ]),
            Positioned(
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
                focusNode: _commentFocusNode,
                onSendButtonClick: _uploadComment,
              ),
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
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
              title: _isFetching
                  ? const SizedBox.shrink()
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvatar(
                              size: 40,
                              avt: '${author.avt}',
                              onTap: _navigateToAuthorProfile),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  author.username!,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                                Text(
                                  timeago.format(
                                      DateTime.parse(_reviewPostDetail
                                          .createDate
                                          .toString()),
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
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_add_outlined),
                  color: Colors.black38,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.black38,
                )
              ],
            )
          ];
        },
      ),
    );
  }

  _uploadComment() async {
    var text = _commentController.text;
    if (text.isEmpty) return;
    try {
      Comment comment = await _postService.commentReviewPost(
          postId: _reviewPostDetail.id!,
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
        // _currentFocusReplyId = null;
      });
    } on Exception catch (e) {
      print(e);
    } finally {
      _commentController.text = lorem(words: 6, paragraphs: 1);
      // _commentFocusNode.unfocus();
    }
  }

  _navigateToAuthorProfile(int id) {
    if (context.read<AuthenticationBloc>().state.user.id == id) return;
    Navigator.push(context, ProfileScreen.route(id));
  }

  _showAttScrollView(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ReviewPostAttachmentScrollView(
        attachments: _reviewPostDetail.images,
        initialIndex: index,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _quillController.dispose();
    _commentFocusNode.unfocus();
    super.dispose();
  }
}
