import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:traveling_social_app/screens/review/question_post_detail_screen.dart';
import 'package:traveling_social_app/screens/search/components/question_entry.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/base_app_bar.dart';

import '../../models/question_post.dart';
import '../profile/components/icon_with_text.dart';

class CurrentUserQuestionsScreen extends StatefulWidget {
  const CurrentUserQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<CurrentUserQuestionsScreen> createState() =>
      _CurrentUserQuestionsState();

  static Route route() => MaterialPageRoute(
      builder: (context) => const CurrentUserQuestionsScreen());
}

class _CurrentUserQuestionsState extends State<CurrentUserQuestionsScreen> {
  final PostService _postService = PostService();
  List<QuestionPost> _questions = [];

  @override
  void initState() {
    super.initState();
    _postService
        .getCurrentUserQuestionPosts()
        .then((value) => setState(() => _questions = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Bài thảo luận của bạn'),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var post = _questions[index];
            return QuestionEntry(
              post: post,
              showMetadata: false,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  QuestionPostDetailScreen.route(post.id!));
                            },
                            child: const Text('Xem')),
                        CupertinoActionSheetAction(
                            onPressed: () async {
                              var isClose = post.isClose;
                              await _postService.closeCommentOnPost(
                                  postId: post.id!, status: isClose ? 0 : 1);
                              if (isClose) {
                                ApplicationUtility.showSuccessToast(isClose
                                    ? "Mở thảo luận bài viết thành công"
                                    : "Đóng thảo luận bài viết thành công");
                              }
                              var list = _questions.map((e) {
                                if (e.id == post.id) {
                                  e.isClose = !e.isClose;
                                }
                                return e;
                              }).toList();
                              setState(() {
                                _questions = list;
                              });

                              Navigator.pop(context);
                            },
                            child: Text(post.isClose
                                ? 'Mở thảo luận'
                                : 'Đóng thảo luận')),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  QuestionPostDetailScreen.route(post.id!));
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
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeago.format(DateTime.parse('${post.createDate}'),
                        locale: Localizations.localeOf(context).languageCode),
                    style: const TextStyle(
                        color: Colors.black54, letterSpacing: .7),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconTextButton(
                      text: '${post.commentCount}',
                      icon: Icon(
                        Icons.comment,
                        color: Colors.black54,
                        size: 16,
                      )),
                ],
              ),
            );
          },
          itemCount: _questions.length,
        ),
      ),
    );
  }
}
