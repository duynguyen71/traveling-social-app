import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print('notification init');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('notification'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
