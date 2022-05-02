import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/services/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  List<Post> _stories = [];

  int _currentStoryIndex = 0;

  void fetchStories() async {
    print('fetch stor');
    _stories = await _postService.getPosts();
    print(_stories);
    notifyListeners();
  }

  set setCurrentStoryIndex(index) {
    _currentStoryIndex = index;
  }

  removeStory(int storyId) {
    _stories.removeWhere((story) => story.id == storyId);
    print('item remain ${_stories.length}');
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
