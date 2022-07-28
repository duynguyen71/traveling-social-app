import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print('bookmark init');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('bookmark'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
