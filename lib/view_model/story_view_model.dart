
import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/services/post_service.dart';

class StoryViewModel extends ChangeNotifier {
  StoryViewModel() {
    fetchStories();
  }

  final PostService _postService = PostService();

  Set<Post> _stories = <Post>{};

  int _currentStoryIndex = 0;
  int _currentPage = 0;
  final bool _isLoading = false;

  void fetchStories({int? page, int? pageSize}) async {
    _currentPage = 0;
    List<Post> rs =
        await _postService.getStories(page: page ?? 0, pageSize: pageSize ?? 5);
    if (rs.isNotEmpty) {
      _stories.addAll(rs);
      notifyListeners();
    }
  }

  void updateStories({int? pageSize}) async {
    _currentPage = _currentPage + 1;
    List<Post> resp = await _postService.getStories(
        page: _currentPage, pageSize: pageSize ?? 5);
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

  bool get isLoading => _isLoading;

  removeStory(int storyId) {
    _stories.removeWhere((story) => story.id == storyId);
    _postService.hidePost(postId: storyId);
    notifyListeners();
  }

  addStory(Post story) {
    _stories = <Post>{story}.union(_stories);
    notifyListeners();
  }

  clear() {
    _stories = <Post>{};
    notifyListeners();
  }

  bool next() {
    if (stories.length - 1 == _currentStoryIndex) {
      return false;
    } else {
      // print('next');
      stories.removeWhere((element) => element.id==_stories.elementAt(_currentStoryIndex).id);
      // setCurrentStoryIndex = _currentStoryIndex+1;
      notifyListeners();
      return true;
    }
  }

  //getters
  Set<Post> get stories => _stories;

  int get currentStoryIndex => _currentStoryIndex;
}
