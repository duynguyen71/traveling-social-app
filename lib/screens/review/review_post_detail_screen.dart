import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_tags.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/screens/review/components/review_post_att_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/widgets/comment_input_reply_widget.dart';
import '../../constants/api_constants.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/Author.dart';
import '../../models/review_post_detail.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
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
  final _userService = UserService();
  bool _isFetching = true;
  bool _isBookmarked = false;
  late ReviewPostDetail _reviewPostDetail;
  late quill.QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();
  final _commentController = TextEditingController();
  Set<Comment> _comments = {};
  Author _author = Author.empty();

  _getReviewPostDetail() async {
    setState(() => _isFetching = true);
    var data = await _postService.getReviewPostDetail(id);
    if (data != null) {
      _quillController = quill.QuillController(
          document: quill.Document.fromJson(jsonDecode(data.contentJson!)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {
        _reviewPostDetail = data;
        _isBookmarked = _reviewPostDetail.hasBookmark;
        _isFetching = false;
      });
      _getAuthor();
    }
  }

  _getAuthor() async {
    var auth =
        await _postService.getReviewPostAuthInfo(reviewPostId: widget.id);
    setState(() => _author = auth);
  }

  int get id => widget.id;

  @override
  void initState() {
    super.initState();
    _getReviewPostDetail();
    _commentController.text = lorem(paragraphs: 1, words: 12);
  }

  final _scrollController = ScrollController();
  Comment? _replyComment;
  int? _currentFocusReplyId;
  int? _removedCommentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        body: RefreshIndicator(
          onRefresh: () async {
            await _getReviewPostDetail();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                    addAutomaticKeepAlives: true,
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      _isFetching
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            )
                          : Column(
                              children: [
                                // POST TITLE
                                ReviewPostTitle(
                                  title: _reviewPostDetail.title!,
                                  padding: const EdgeInsets.only(top: 8.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              alignment: Alignment.centerRight,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap),
                                          onPressed: () {},
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                    _reviewPostDetail
                                                        .numOfVisitor
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14)),
                                              ),
                                              const Icon(
                                                Icons.visibility,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                // POST COVER IMAGE
                                CoverImageContainer(
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    child: ClipRRect(
                                      borderRadius: kReviewPostBorderRadius,
                                      child: CachedNetworkImage(
                                        alignment: Alignment.center,
                                        imageUrl:
                                            '$imageUrl${_reviewPostDetail.coverPhoto!.name}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                // QUILL CONTROLLER
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                              ],
                            ),
                      (_isFetching || _reviewPostDetail.images.isEmpty)
                          ? const SizedBox.shrink()
                          : Container(
                              height: 120,
                              constraints: const BoxConstraints(minHeight: 120),
                              // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _showAttScrollView(index);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
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
                      //ABOUT AUTHOR
                      _isFetching
                          ? const SizedBox.shrink()
                          : AuthTag(
                              auth: _author,
                              onTapFollow: () async {
                                if (_author.isFollowing) {
                                  await _userService.unFollow(
                                      userId: _author.id!);
                                } else {
                                  await _userService.follow(
                                      userId: _author.id!);
                                }
                                setState(() {
                                  _author = _author.copyWith(
                                      isFollowing: !_author.isFollowing);
                                });
                              },
                            ),
                      // TAGS
                      _isFetching
                          ? const SizedBox()
                          : ReviewPostTags(
                              tags: _reviewPostDetail.tags, onTap: (tag) {}),
                      // REACTION BAR
                      _isFetching
                          ? const SizedBox.shrink()
                          : ReactionBar(
                              isLoved: _reviewPostDetail.myReaction != null,
                              onLike: (int? type) async {
                                await _postService.reactionReviewPost(
                                    reviewPostId: _reviewPostDetail.id!,
                                    reactionId: type);
                              },
                              onComment: () {
                                setState(() {
                                  _commentFocusNode.requestFocus();
                                });
                              },
                              onShare: () {},
                              numOfReaction: _reviewPostDetail.numOfReaction,
                              numOfComment: _reviewPostDetail.numOfComment,
                            ),
                      _isFetching
                          ? const SizedBox.shrink()
                          : ReviewPostCommentSection(
                              currentFocusReplyId: _currentFocusReplyId,
                              postId: _reviewPostDetail.id!,
                              currentReplyId: _replyComment?.id,
                              comments: _comments,
                              setReplyComment: (e) {
                                setState(() => _replyComment = e);
                              },
                              hideComment: (id) {},
                              setRemoveCommentId: (id) {
                                if (id == null) {
                                  setState(() {
                                    _removedCommentId = null;
                                  });
                                  return;
                                }
                                _postService.hideReviewPostComment(
                                    commentId: id);
                                setState(() {
                                  _removedCommentId = id;
                                });
                              },
                              removedCommentId: _removedCommentId,
                              getComments: () async {
                                final resp =
                                    await _postService.getReviewPostComments(
                                        postId: _reviewPostDetail.id!);
                                setState(() => _comments = resp);
                              },
                            ),
                      // SPACER
                      const SizedBox(
                        height: 100,
                      ),
                    ]),
              ),
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
                              avt: '${_author.avt}',
                              onTap: _navigateToAuthorProfile),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _author.username!,
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
              elevation: 0,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey.shade200,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(1)),
              actions: [
                IconButton(
                  onPressed: _bookmarkPost,
                  icon: _isBookmarked
                      ? const Icon(
                          Icons.bookmark_add_rounded,
                          color: Colors.lightBlue,
                        )
                      : const Icon(Icons.bookmark_add_outlined),
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

  _bookmarkPost() async {
    bool success =
        await _postService.saveBookmark(postId: _reviewPostDetail.id);
    if (success) {
      setState(() {
        _isBookmarked = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quillController.dispose();
    _commentController.dispose();
    _focusNode.dispose();
    _commentFocusNode.unfocus();
    super.dispose();
  }
}
