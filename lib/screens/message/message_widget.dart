import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

import '../../constants/app_theme_constants.dart';

class MessageWidget extends StatefulWidget {
  final bool isSender;
  final bool isFirst;
  final String message;
  final Color color;
  final bool isLast;
  final Function onLongPress;
  final bool isFavorite;
  final String timeFormat;
  final Function onDoubleTap;
  final String? avt;
  final bool hasError;

  const MessageWidget({
    Key? key,
    required this.isSender,
    required this.message,
    required this.color,
    required this.isLast,
    required this.isFirst,
    required this.onLongPress,
    required this.isFavorite,
    required this.onDoubleTap,
    required this.timeFormat,
    this.avt,
    required this.hasError,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late bool showTime;

  @override
  void initState() {
    showTime = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: widget.isFirst
          ? const EdgeInsets.only(
              top: 20,
            )
          : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !widget.isSender,
            child: UserAvatar(
              onTap: () {},
              avt: widget.avt,
              size: 35,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: widget.isLast
                    ? const EdgeInsets.only(bottom: 20)
                    : EdgeInsets.zero,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showTime = !showTime;
                          });
                        },
                        onDoubleTap: () => widget.onDoubleTap(),
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(40),
                        // onTap: () {},
                        onLongPress: () =>
                            // Timer(Duration(milliseconds: 180), () {
                            widget.onLongPress()
                        // });
                        ,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: size.width * .015,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: size.width * .7,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.color,
                            boxShadow: const [],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isLast || showTime,
                      //  && !widget.isSender,
                      child: Container(
                        // alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding / 2),
                        child: Text(
                          widget.timeFormat,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: widget.isFavorite,
                child: Positioned(
                    top: -15,
                    right: 0,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite, color: Colors.pink[300]))),
              ),
              Visibility(
                visible: widget.isLast && !widget.isSender,
                child: Positioned(
                  right: -10,
                  top: 20,
                  child: Icon(
                    Icons.check,
                    color: Colors.pink[200],
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            child: const Center(
                child: Icon(
              Icons.error_outline,
              color: Colors.red,
            )),
            visible: widget.hasError,
          ),
        ],
      ),
    );
  }
}
