import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/Post.dart';

import '../services/post_service.dart';

class PostViewModel with ChangeNotifier {
  final PostService _postService = PostService();

  Set<Post> _posts = <Post>{};

  int _page = 0;

  void fetchPosts() async {
    _page = 0;
    var data = await _postService.getPosts(page: _page, pageSize: 4);
    _posts.addAll(data);
    notifyListeners();
  }

  void fetchMorePosts() async {
    _page = _page + 1;
    var data = await _postService.getPosts(page: _page, pageSize: 4);
    _posts.addAll(data);
    if (data.isEmpty) {
      _page = _page - 1;
    }
    notifyListeners();
  }

  void addPost(Post post) {
    _posts = <Post>{post}.union(_posts);
    notifyListeners();
  }

  clear() {
    _posts = <Post>{};
  }

  //getters
  Set<Post> get posts => _posts;
}
