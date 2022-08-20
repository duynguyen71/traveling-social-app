import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_theme_constants.dart';

class EmptyMessageWidget extends StatelessWidget {
  const EmptyMessageWidget({Key? key, required this.message, this.icon}) : super(key: key);
  final String message;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child:icon!=null? icon: SvgPicture.asset(
            'assets/icons/inbox_message.svg',
            color: kPrimaryColor.withOpacity(.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                letterSpacing: .8),
          ),
        ),
      ],
    );
  }
}
