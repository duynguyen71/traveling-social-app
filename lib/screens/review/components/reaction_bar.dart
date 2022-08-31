import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReactionBar extends StatefulWidget {
  const ReactionBar(
      {Key? key,
      required this.onLike,
      required this.onComment,
      required this.onShare,
      this.isLoved = false,
      required this.numOfReaction,
      required this.numOfComment})
      : super(key: key);

  final Function onLike, onComment, onShare;
  final bool isLoved;
  final int numOfReaction, numOfComment;

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar>
    with AutomaticKeepAliveClientMixin {
  bool _isFavorite = false;
  int _numOfReaction = 0, _numOfComment = 0;

  @override
  void didChangeDependencies() {
    if (widget.isLoved) {
      setState(() {
        _isFavorite = true;
      });
    }
    setState(() {
      _numOfReaction = widget.numOfReaction;
      _numOfComment = widget.numOfComment;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(.05),
        border: Border(
          top: BorderSide(width: .1, color: Colors.grey.shade400),
          bottom: BorderSide(width: .1, color: Colors.grey.shade400),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
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
                    widget.onLike(_isFavorite ? null : 1);
                    setState(() {
                      _isFavorite = !_isFavorite;
                      _numOfReaction = _isFavorite
                          ? (_numOfReaction + 1)
                          : (_numOfReaction - 1);
                    });
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
                        ? Icon(
                            size: 24.0,
                            Icons.favorite,
                            color: Colors.red,
                            key: ValueKey('icon1'),
                          )
                        : Icon(
                            size: 24.0,
                            Icons.favorite_border,
                            color: Colors.black45,
                            key: ValueKey('icon2'),
                          ),
                  ),
                ),
                Text(_numOfReaction.toString()),
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
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
                Text(
                  _numOfComment.toString(),
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
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
