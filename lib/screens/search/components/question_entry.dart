import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/question_post.dart';

import '../../review/components/post_meta.dart';

class QuestionEntry extends StatelessWidget {
  const QuestionEntry(
      {Key? key,
      required this.post,
      this.showMetadata = false,
      this.child,
      this.onTap})
      : super(key: key);
  final QuestionPost post;
  final bool showMetadata;
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.caption ?? '',
                    overflow: TextOverflow.ellipsis,
                    // maxLines: 2,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      post.isClose ? 'Đã đóng' : 'Đang mở',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: post.tags
                  .map((e) => Text(
                        '#${e.name}',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                        ),
                      ))
                  .toList(),
            ),
            Visibility(
              visible: showMetadata,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PostMetadata(
                  username: post.user?.username ?? '',
                  createDate: post.createDate,
                  showBookmark: false,
                ),
              ),
            ),
            child ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
