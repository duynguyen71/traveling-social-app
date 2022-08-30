import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/review/components/post_meta.dart';
import 'package:traveling_social_app/screens/review/question_post_detail_screen.dart';
import 'package:traveling_social_app/screens/search/components/question_entry.dart';
import 'package:traveling_social_app/screens/search/components/search_result_list_container.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

import '../../../models/Base_review_post_response.dart';
import '../../../models/post.dart';
import '../../../models/question_post.dart';
import '../../../services/post_service.dart';
import '../../review/components/review_post_entry.dart';
import '../../review/review_post_detail_screen.dart';

class QuestionSearch extends StatefulWidget {
  const QuestionSearch({Key? key, this.keyWord}) : super(key: key);
  final String? keyWord;

  @override
  State<QuestionSearch> createState() => _QuestionSearchState();
}

class _QuestionSearchState extends State<QuestionSearch>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<QuestionPost> _posts = [];

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
      var posts = await _postService.searchQuestions(widget.keyWord);
      setState(() => _posts = posts);
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SearchResultListContainer(
            isLoading: _isLoading,
            list: _posts,
            child: (c) {
              var post = c as QuestionPost;
              return QuestionEntry(
                post: post,
                onTap: () => Navigator.push(
                    context, QuestionPostDetailScreen.route(post.id!)),
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
