import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/scroll_end_notification.dart';

import '../../../models/post.dart';
import '../../explore/components/post_entry.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key, required this.fetchPosts}) : super(key: key);
  final Future<List<Post>> Function(int? page, int? pageSize) fetchPosts;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final Set<Post> _posts = {};
  bool _hasReachMax = false;
  int _page = 0;
  bool _isLoading = false;

  _fetchPost() {
    if (_hasReachMax || _isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    widget.fetchPosts(_page, 5).then((value) {
      if (value.isEmpty) {
        setState(() {
          _hasReachMax = true;
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _posts.addAll(value);
        _isLoading = false;
        _page += 1;
      });
    });
  }

  @override
  void initState() {
    _fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScrollEndNotification(
      onEndNotification: (no) {
        if (_isLoading || _hasReachMax) return false;
        _fetchPost();
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          var post = _posts.elementAt(index);
          return PostEntry(post: post);
        },
        itemCount: _posts.length,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
