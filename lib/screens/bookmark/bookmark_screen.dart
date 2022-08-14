import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/review_post_detail.dart';
import 'package:traveling_social_app/screens/review/components/review_post_entry.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/Base_review_post_response.dart';
import '../../services/post_service.dart';
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
            });
          },
          child: ListView.builder(
            addAutomaticKeepAlives: true,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var post = _bookmarks[index];
              return Dismissible(
                background: Container(
                  color: Colors.red,
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  _bookmarks.removeAt(index);
                },
                key: Key(post.id.toString()),
                child: ReviewPostEntry(
                  post: post,
                  showFooter: false,
                  coverImgHeight: 40,
                  onTap: () => Navigator.push(
                      context, ReviewPostDetailScreen.route(post.id!)),
                ),
              );
            },
            itemCount: _bookmarks.length,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
