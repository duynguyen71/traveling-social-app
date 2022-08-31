import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/services/post_service.dart';

import '../../models/post.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final PostService _postService = PostService();

  StoryBloc() : super(const StoryState.initial()) {
    on<FetchStory>(_fetchStories);
    on<UpdateScrollIndex>(_updateScrollIndex);
    on<ResetStoryState>(_clear);
    on<AddStory>(_addCurrentUserStory);
    on<RemoveStory>(_removeStory);
  }

  _fetchStories(FetchStory event, emit) async {
    if (event.isRefreshing) {
      emit(state.copyWith(
          hasReachMax: false,
          page: 0,
          stories: {},
          status: StoryStateStatus.initial));
    }
    if (state.hasReachMax || state.status == StoryStateStatus.fetching) {
      return;
    }
    try {
      emit(state.copyWith(status: StoryStateStatus.fetching));
      Set<Post> stories = await _postService.getStories(
          page: state.page, pageSize: state.pageSize);
      bool hasReachMax = true;
      int page = state.page;
      if (stories.isNotEmpty) {
        hasReachMax = false;
        page = page + 1;
      }
      emit(
        state.copyWith(
            hasReachMax: hasReachMax,
            page: page,
            status: StoryStateStatus.success,
            stories: {...state.stories, ...stories}),
      );
    } on Exception {
      emit(state.copyWith(status: StoryStateStatus.failed));
    }
  }

  _updateScrollIndex(UpdateScrollIndex event, emit) {
    if (event.index < 0 || event.index >= state.stories.length) {
      return;
    }
    emit(state.copyWith(currentScrollIndex: event.index));
  }

  _clear(event, emit) {
    emit(const StoryState.initial());
  }

  _addCurrentUserStory(AddStory event, emit) {
    emit(state.copyWith(stories: {event.story, ...state.stories}));
  }

  _removeStory(RemoveStory event, emit) async {
    try {
      await _postService.hidePost(postId: event.id);
      var copyStories = {...state.stories};
      copyStories.removeWhere((element) => element.id == event.id);
      emit(state.copyWith(stories: copyStories));
      print('review story ${event.id} success');
    } on Exception catch (e) {
      emit(state.copyWith(status: StoryStateStatus.failed));
    }
  }
}
