import 'package:flutter/material.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/expandable_text.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:provider/provider.dart';

class CommentEntry extends StatelessWidget {
  const CommentEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(
          size: 30,
          user: context.read<UserViewModel>().user!,
          margin: EdgeInsets.zero,
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .7,
                minWidth: 200,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10)),
              child: ExpandableText(
                  text: 'Loremisfbakfbdasjkdgjkadgfkjasgdfkjasfgjkssgfkjsdf',
                  textColor: Colors.black87),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Like'),
                  SizedBox(
                    width: 20,
                  ),
                  Text('answer')
                ],
              ),
            ),
            // Text('view all reply')
          ],
        ),
      ],
    );
  }
}
