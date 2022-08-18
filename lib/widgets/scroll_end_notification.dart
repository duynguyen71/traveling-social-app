import 'package:flutter/material.dart';

class MyScrollEndNotification extends StatelessWidget {
  const MyScrollEndNotification(
      {Key? key, required this.child, required this.onEndNotification})
      : super(key: key);
  final Widget child;
  final bool Function(ScrollNotification no) onEndNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (notification) {
        var position = notification.metrics;
        if (position.pixels == position.maxScrollExtent) {
          return onEndNotification(notification);
        }
        return false;
      },
    );
  }
}
