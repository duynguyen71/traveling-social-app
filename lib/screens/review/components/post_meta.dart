import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart'as timeago;


class PostMetadata extends StatelessWidget {
  const PostMetadata({Key? key, required this.username, required this.createDate}) : super(key: key);
final String? username,createDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '$username',
                  style: const TextStyle(color: Colors.blue)),
              const TextSpan(text: ' - '),
              TextSpan(
                  text: timeago.format(
                      DateTime.parse('$createDate'),
                      locale: Localizations.localeOf(context)
                          .languageCode)),
            ],
          ),
          style: const TextStyle(
            fontSize: 14,
          ),
          maxLines: 1,
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_add_outlined,
            color: Colors.black54,
            size: 18,
          ),
        )
      ],
    );
  }
}
