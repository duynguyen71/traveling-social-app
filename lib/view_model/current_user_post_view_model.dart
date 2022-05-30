import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/services/post_service.dart';

import '../models/Post.dart';

class CurrentUserPostViewModel with ChangeNotifier {
  final PostService _postService = PostService();

  Set<Post> _posts = <Post>{};

  Set<Post> get posts => _posts;

  int _page = 0;

  int get page => _page;

  bool _isFetched = false;

  bool get isFetched => _isFetched;

  getPosts() async {
    _isFetched = true;
    _page = 0;
    _posts.addAll(
        await _postService.getCurrentUserPosts(page: _page, pageSize: 5));
    notifyListeners();
  }

  fetchMorePosts() async {
    _page = _page + 1;
    List<Post> rs =
        await _postService.getCurrentUserPosts(page: _page, pageSize: 5);
    if (rs.isEmpty) {
      _page = _page - 1;
    } else {
      _posts.addAll(rs);
      notifyListeners();
    }
  }

  removePost({required int postId}) {
    _posts.removeWhere((element) => element.id == postId);
    notifyListeners();
  }

  addPost(Post post) {
    _posts = <Post>{post}.union(_posts);
    notifyListeners();
  }

  clear(){
    _posts.clear();
  }
}
