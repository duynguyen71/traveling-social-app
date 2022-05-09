import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/services/post_service.dart';

class StoryViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  List<Post> _stories = [];

  int _currentStoryIndex = 0;
  int _currentPage = 0;

  void fetchStories({int? page, int? pageSize}) async {
    _currentPage = 0;
    _stories =
        await _postService.getStories(page: page ?? 0, pageSize: pageSize ?? 5);
    if (stories.isNotEmpty) {
      print(_stories);
      notifyListeners();
      return;
    }
  }

  void updateStories() async {
    _currentPage = _currentPage + 1;
    List<Post> resp =
        await _postService.getStories(page: _currentPage, pageSize: 5);
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
    _stories.insert(0, story);
    notifyListeners();
  }

  //getters
  List<Post> get stories => _stories;

  int get currentStoryIndex => _currentStoryIndex;
}
