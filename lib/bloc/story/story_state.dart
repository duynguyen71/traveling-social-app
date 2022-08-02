part of 'story_bloc.dart';

enum StoryStateStatus {
  initial,
  fetching,
  success,
  failed,
}

class StoryState {
  final StoryStateStatus status;

  final Set<Post> stories;

  final bool hasReachMax;

  final int page;

  final int pageSize;

  final int currentScrollIndex;

  const StoryState._(
      {this.status = StoryStateStatus.initial,
      this.stories = const <Post>{},
      this.hasReachMax = false,
      this.page = 0,
      this.pageSize = 4,
      this.currentScrollIndex = 0});

  StoryState copyWith(
          {bool? hasReachMax,
          int? page,
          int? pageSize,
          Set<Post>? stories,
          StoryStateStatus? status,
          int? currentScrollIndex}) =>
      StoryState._(
          page: page ?? this.page,
          pageSize: pageSize ?? this.pageSize,
          stories: stories ?? this.stories,
          currentScrollIndex: currentScrollIndex ?? this.currentScrollIndex,
          hasReachMax: hasReachMax ?? this.hasReachMax,
          status: status ?? this.status);

  const StoryState.initial() : this._();
}
