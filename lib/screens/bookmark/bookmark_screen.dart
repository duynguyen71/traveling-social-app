import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/screens/review/components/post_meta.dart';
import 'package:traveling_social_app/screens/review/components/review_post_entry.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';

import '../../models/Base_review_post_response.dart';
import '../../services/post_service.dart';
import '../../widgets/empty_mesage_widget.dart';
import '../review/review_post_detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<BaseReviewPostResponse> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _getBookmarks();
  }

  _getBookmarks() async {
    if (_hasReachMax || _isLoading) return;
    setState(() => _isLoading = true);
    var data =
        await _postService.getBookmarkedReviewPosts(page: _page, pageSize: 8);
    if (data.isEmpty) {
      setState(() {
        _hasReachMax = true;
      });
    } else {
      setState(() {
        _bookmarks = data;
        _page = _page + 1;
        _hasReachMax = false;
      });
    }
    setState(() => _isLoading = false);
  }

  int _page = 0;
  bool _hasReachMax = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          BaseSliverAppBar(
              title: AppLocalizations.of(context)!.bookmark, actions: const [])
        ];
      },
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          var position = scrollNotification.metrics;
          if (position.pixels == position.maxScrollExtent &&
              !_hasReachMax &&
              !_isLoading) {
            _getBookmarks();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final rs = await _postService.getBookmarkedReviewPosts(
                page: 0, pageSize: 8);
            setState(() {
              _bookmarks = rs;
              _page = 1;
              _hasReachMax = false;
              _isLoading = false;
            });
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              (_bookmarks.isEmpty && !_isLoading)
                  ? Positioned(
                      child: Center(
                        child: EmptyMessageWidget(
                          message: AppLocalizations.of(context)!.notInformation,
                          icon: Transform.rotate(
                              angle: -math.pi / 12,
                              child: SvgPicture.asset(
                                  'assets/icons/bookmark.svg',
                                  color: Colors.black54)),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              ListView.builder(
                addAutomaticKeepAlives: true,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var post = _bookmarks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child:  Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Xóa',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                            Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      assert(post.id != null);
                      _removeBookmark(post.id!, index);
                    },
                    child: ReviewPostEntry(
                      imageName: post.coverPhoto?.name,
                      title: post.title,
                      showFooter: false,
                      coverImgHeight: 40,
                      onTap: () => Navigator.push(
                          context, ReviewPostDetailScreen.route(post.id!)),
                      child: PostMetadata(
                        showBookmark: false,
                          username: post.user?.username,
                          createDate: post.createDate),
                    ),
                  );
                },
                itemCount: _bookmarks.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeBookmark(int id, int index) async {
    bool success = await _postService.removeBookmark(id);
    if (success) {
      print('remove bookmark post id: $id success!');
      _bookmarks.removeAt(index);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
