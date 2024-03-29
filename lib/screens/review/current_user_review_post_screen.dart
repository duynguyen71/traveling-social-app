import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/screens/create_review/create_review_post_screen.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';
import 'package:traveling_social_app/screens/review/components/review_post_entry.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';

import '../../models/Review_post_report.dart';
import '../../services/post_service.dart';
import 'review_post_detail_screen.dart';

class CurrentUserReviewPostScreen extends StatefulWidget {
  const CurrentUserReviewPostScreen({Key? key}) : super(key: key);

  @override
  State<CurrentUserReviewPostScreen> createState() =>
      _CurrentUserReviewPostScreenState();

  static Route route() => MaterialPageRoute(
        builder: (context) => const CurrentUserReviewPostScreen(),
      );
}

class _CurrentUserReviewPostScreenState
    extends State<CurrentUserReviewPostScreen>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<ReviewPostReport> _posts = [];

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  // Get current user review posts active
  _getPosts() {
    _postService
        .getCurrentUserReviewPosts()
        .then((value) => setState(() => _posts.addAll(value.reversed)));
  }

  void _showActionModalPopup(BuildContext context, int? id) {
    assert(id != null);
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, ReviewPostDetailScreen.route(id!));
                },
                child: const Text('Xem')),
            CupertinoActionSheetAction(
                onPressed: () async {
                  assert(id != null);
                  var creationReviewPost = await _postService
                      .getCurrentUserEditReviewPostDetail(id!);
                  if (creationReviewPost != null) {
                    context
                        .read<CreateReviewPostCubit>()
                        .setReviewPost(creationReviewPost);
                    Navigator.pop(context);
                    Navigator.push(context, CreateReviewPostScreen.route());
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Chỉnh sửa')),
            CupertinoActionSheetAction(
                onPressed: () async {
                  assert(id != null);
                  var creationReviewPost = await _postService
                      .getCurrentUserEditReviewPostDetail(id!);
                  if (creationReviewPost != null) {
                    context
                        .read<CreateReviewPostCubit>()
                        .setReviewPost(creationReviewPost);
                    Navigator.pop(context);
                    Navigator.push(context, CreateReviewPostScreen.route());
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Xóa')),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const BaseSliverAppBar(
                title: 'Bài Review của bạn',
                isShowLeading: true,
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              await _getPosts();
            },
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                ListView.builder(
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var post = _posts[index];
                    var updateDate = DateTime.parse(post.updateDate.toString());
                    return ReviewPostEntry(
                      title: post.title,
                      imageName: post.coverPhoto?.name,
                      onTap: () {
                        _showActionModalPopup(context, post.id);
                      },
                      coverImgHeight: 40,
                      showFooter: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconTextButton(
                                text: '${post.numOfVisitor}',
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.lightBlue,
                                  size: 16,
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconTextButton(
                                  text: '${post.numOfLike}',
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 16,
                                  )),
                            ),
                            IconTextButton(
                                text: '${post.numOfComment}',
                                icon: Icon(
                                  Icons.comment,
                                  color: Colors.black54,
                                  size: 16,
                                )),
                            Expanded(
                              child: Text(
                                'Lần cuối chỉnh sửa ${timeago.format(updateDate, locale: Localizations.localeOf(context).languageCode)}',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _posts.length,
                  shrinkWrap: true,
                )
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
