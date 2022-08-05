import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_theme_constants.dart';

class ReactionBar extends StatefulWidget {
  const ReactionBar(
      {Key? key,
      required this.onLike,
      required this.onComment,
      required this.onShare})
      : super(key: key);

  final Function onLike, onComment, onShare;

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(.05),
        // borderRadius: BorderRadius.circular(40),
        // border: Border.all(width: .1, color: Colors.grey.shade400),
        border: Border(
          top: BorderSide(width: .1, color: Colors.grey.shade400),
          bottom: BorderSide(width: .1, color: Colors.grey.shade400),
        ),
        // boxShadow: [
        //   kDefaultPostActionBarShadow,
        // ]
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    widget.onLike();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: child.key == const ValueKey('icon1')
                          ? Tween<double>(begin: !_isFavorite ? 1 : 1.5, end: 1)
                              .animate(animation)
                          : Tween<double>(begin: _isFavorite ? 1 : 1.5, end: 1)
                              .animate(animation),
                      child: child,
                    ),
                    child: _isFavorite
                        ? const Icon(
                            size: kDefaultBottomNavIconSize,
                            Icons.favorite,
                            color: Colors.red,
                            key: ValueKey('icon1'),
                          )
                        : const Icon(
                            size: kDefaultBottomNavIconSize,
                            Icons.favorite_border,
                            color: Colors.black45,
                            key: ValueKey('icon2'),
                          ),
                  ),
                ),
                Text(11.toString()),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {
                    widget.onComment();
                  },
                  // icon: const Icon(
                  //   Icons.chat_bubble_outline,
                  //   color: Colors.black87,
                  // ),
                  icon: SvgPicture.asset(
                    'assets/icons/comment.svg',
                    width: kDefaultBottomNavIconSize,
                    height: kDefaultBottomNavIconSize,
                  ),
                ),
                Text(
                  11.toString(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/share.svg',
                    width: kDefaultBottomNavIconSize,
                    height: kDefaultBottomNavIconSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
