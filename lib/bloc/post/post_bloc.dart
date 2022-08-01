import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:traveling_social_app/services/comment_service.dart';
import 'package:traveling_social_app/services/post_service.dart';

import '../../models/post.dart';
import 'package:collection/collection.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService _postService = PostService();
  final CommentService _commentService = CommentService();

  PostBloc() : super(const PostState.initial()) {
    on<FetchPost>(_handleFetchPost);
    on<RemovePost>(_removeCurrentUserPost);
    on<AddPost>(_addCurrentUserPost);
    on<Reset>(_reset);
    on<IncrementCommentCount>(_incrementCommentCount);
    on<RemoveComment>(_removeComment);
  }

  /// Handle get posts
  _handleFetchPost(event, emit) async {
    if (event is FetchPost) {
      // fetch post if post hasReachMax = false && PostStateStatus != Fetching
      if (!state.hasReachMax && state.status != PostStateStatus.fetching) {
        try {
          emit(state.copyWith(
            status: PostStateStatus.fetching,
          ));
          Set<Post> posts =
              await _postService.getPosts(page: state.page, pageSize: 4);
          // stop fetching if hasReachMax
          bool hasReachMax = false;
          // get next page value
          int nextPage = state.page;
          if (posts.isEmpty) {
            print('post reach max');
            hasReachMax = true;
          } else {
            nextPage += 1;
          }
          // Copy posts
          Set<Post> postState = {...state.posts, ...posts};
          emit(state.copyWith(
              posts: postState,
              page: nextPage,
              hasReachMax: hasReachMax,
              status: PostStateStatus.success));
        } on Exception catch (e) {
          emit(state.copyWith(status: PostStateStatus.failed));
        }
      }
    }
  }

  _incrementCommentCount(IncrementCommentCount event, emit) {
    int id = event.postId;
    Set<Post> copyPosts = {...state.posts};
    Post post = copyPosts.singleWhere((element) => element.id == id);
    post.commentCount = post.commentCount + 1;
    emit(state.copyWith(posts: copyPosts));
  }

  _removeComment(RemoveComment event, emit) {
    int id = event.id;
    Set<Post> copyPosts = <Post>{...state.posts};
    Post? post = state.posts.singleWhereOrNull((element) => element.id == id);
    // copyPosts.sin
    if (post != null) {
      try {
        _commentService.hideComment(commentId: event.commentId);
        post.myComments.removeWhere((element) => element.id == event.commentId);
        post.commentCount = post.commentCount - 1;
        emit(state.copyWith(posts: copyPosts));
      } on Exception catch (e) {
        rethrow;
      }
    }
  }

  /// Handle remove current user post
  _removeCurrentUserPost(RemovePost event, emit) async {
    try {
      emit(state.copyWith(status: PostStateStatus.fetching));
      Set<Post> modifiedPosts = <Post>{...state.posts};
      // request hiding post
      await _postService.hidePost(postId: event.id);
      modifiedPosts.removeWhere((element) => event.id == element.id);
      emit(state.copyWith(
          posts: modifiedPosts, status: PostStateStatus.success));
    } on Exception catch (e) {
      emit(state.copyWith(status: PostStateStatus.failed));
    }
  }

  /// Reset to default state
  _reset(event, emit) {
    emit(const PostState.initial());
  }

  /// Add new post from current user
  _addCurrentUserPost(AddPost event, emit) {
    emit(state.copyWith(posts: <Post>{event.post}.union({...state.posts})));
  }
}
