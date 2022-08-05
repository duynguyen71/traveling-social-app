import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/screens/review/components/review_post_att_scroll_view.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/comment_entry.dart';
import 'package:provider/provider.dart';
import '../../constants/api_constants.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/base_user.dart';
import '../../models/review_post_details.dart';
import '../../services/post_service.dart';
import '../../widgets/my_outline_button.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/user_avt.dart';
import '../create_review/components/cover_image_container.dart';
import '../create_review/components/review_post_title.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../profile/components/follow_count.dart';
import 'components/auth_tag.dart';
import 'components/reaction_bar.dart';

class ReviewPostDetailScreen extends StatefulWidget {
  const ReviewPostDetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ReviewPostDetailScreen> createState() => _ReviewPostDetailScreenState();

  static Route route(int id) =>
      MaterialPageRoute(builder: (_) => ReviewPostDetailScreen(id: id));
}

class _ReviewPostDetailScreenState extends State<ReviewPostDetailScreen> {
  //get review post detail

  final _postService = PostService();
  bool _isFetching = true;
  late ReviewPostDetails _reviewPostDetail;
  late quill.QuillController _quillController;

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
    super.initState();
    _getReviewPostDetail();
  }

  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  BaseUserInfo get author => _reviewPostDetail.user!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                const Text(
                                  '4h ago',
                                  style: TextStyle(
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
        body: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              // POST TITLE
              _isFetching
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ReviewPostTitle(title: _reviewPostDetail.title!),
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
                        autoFocus: true,
                        expands: false,
                        padding: EdgeInsets.zero,
                        showCursor: false, // add th
                      ),
                    ),
              _isFetching
                  ? const SizedBox.shrink()
                  : Container(
                      height: kReviewPostMinHeight,
                      constraints:
                          const BoxConstraints(minHeight: kReviewPostMinHeight),
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
                                  borderRadius: kReviewPostImageGalleryBorder,
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
                      onComment: () {},
                      onShare: () {},
                    ),
              // CommentEntry(
              //     comment: Comment(1,'afhl',),
              //     level: level,
              //     postId: postId,
              //     isShowChildren: isShowChildren,
              //     replyCommentRequest: replyCommentRequest,
              //     hideComment: hideComment,
              //     editCommentRequest: editCommentRequest),
              const SizedBox(
                height: 200,
              ),
            ]),
      ),
    );
  }

  _navigateToAuthorProfile(int id) {
    if (context.read<AuthenticationBloc>().state.user.id == id) return;
    Navigator.push(context, ProfileScreen.route(id));
  }

  _showAttScrollView(int index) {
    print('show tt scroll view');
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
}
