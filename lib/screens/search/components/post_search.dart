import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/search/components/search_result_list_container.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

import '../../../models/Base_review_post_response.dart';
import '../../../services/post_service.dart';
import '../../review/components/review_post_entry.dart';
import '../../review/review_post_detail_screen.dart';

class PostSearch extends StatefulWidget {
  const PostSearch({Key? key, this.keyWord}) : super(key: key);
  final String? keyWord;

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<BaseReviewPostResponse> _posts = [];

  @override
  void didChangeDependencies() {
    ApplicationUtility.hideKeyboard();
    _getPosts();
    super.didChangeDependencies();
  }

  bool _isLoading = true;

  set isLoading(i) => setState(() => _isLoading = i);

  _getPosts() async {
    try {
      var posts = await _postService.searchReviewPosts(widget.keyWord);
      setState(() => _posts = posts);
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SearchResultListContainer(
            isLoading: _isLoading,
            list: _posts,
            child: (c) {
              var post = c as BaseReviewPostResponse;
              return ReviewPostEntry(
                onTap: () {
                  Navigator.push(
                      context, ReviewPostDetailScreen.route(post.id!));
                },
                imageName: post.coverPhoto?.name,
                title: post.title,
                child: Container(),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
