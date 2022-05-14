import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/services/post_service.dart';

class StoryViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  // List<Post> _stories = [];
  Set<Post> _stories = <Post>{};

  int _currentStoryIndex = 0;
  int _currentPage = 0;

  void fetchStories({int? page, int? pageSize}) async {
    _currentPage = 0;
    List<Post> rs =
        await _postService.getStories(page: page ?? 0, pageSize: pageSize ?? 5);
    if (rs.isNotEmpty) {
      _stories.addAll(rs);
      notifyListeners();
      return;
    }
  }

  void updateStories({int? pageSize}) async {
    _currentPage = _currentPage + 1;
    List<Post> resp =
        await _postService.getStories(page: _currentPage, pageSize: pageSize??5);
    if (resp.isNotEmpty) {
      _stories.addAll(resp);
      notifyListeners();
    } else {
      _currentPage = _currentPage - 1;
    }
  }

  set setCurrentStoryIndex(index) {
    _currentStoryIndex = index;
  }

  removeStory(int storyId) {
    _stories.removeWhere((story) => story.id == storyId);
    notifyListeners();
  }

  addStory(Post story) {
    // _stories.insert(0, story);
    // _stories.add(story);
    _stories = <Post>{story}.union(_stories);
    notifyListeners();
  }

  clear() {
    _stories = <Post>{};
  }

  //getters
  Set<Post> get stories => _stories;

  int get currentStoryIndex => _currentStoryIndex;
}
