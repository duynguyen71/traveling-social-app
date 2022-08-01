part of 'post_bloc.dart';

enum PostStateStatus {
  initial,
  fetching,
  success,
  failed,
}

class PostState {
  final PostStateStatus status;
  final Set<Post> posts;
  final bool hasReachMax;
  final int page;
  final int pageSize;

  const PostState._({
    this.status = PostStateStatus.initial,
    this.posts = const <Post>{},
    this.hasReachMax = false,
    this.page = 0,
    this.pageSize = 4,
  });

  PostState copyWith({
    bool? hasReachMax,
    int? page,
    int? pageSize,
    Set<Post>? posts,
    PostStateStatus? status,
  }) =>
      PostState._(
          page: page ?? this.page,
          pageSize: pageSize ?? this.pageSize,
          posts: posts ?? this.posts,
          hasReachMax: hasReachMax ?? this.hasReachMax,
          status: status ?? this.status);

  const PostState.initial() : this._();
//
// const PostState.fetched(Set<Post> posts)
//     : this._(posts: posts, status: PostStateStatus.success);
//
// const PostState.fetching(int currentFetchingPage) : this._(status: PostStateStatus.fetching, page:  currentFetchingPage);
//
// const PostState.success(Set<Post> posts, int nextPage, bool hasReachMax)
//     : this._(
//           posts: posts,
//           status: PostStateStatus.success,
//           page: nextPage,
//           hasReachMax: hasReachMax);
//
// const PostState.failed() : this._(status: PostStateStatus.failed);

// @override
// List<Object?> get props => [status, posts,page,];
}
