part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {
  const PostEvent();
}

@immutable
class FetchPost extends PostEvent {
  final bool isRefreshing;

  const FetchPost({this.isRefreshing = false});

  @override
  List<Object?> get props => [];
}

/// event to add post to position 0 of posts list
@immutable
class AddPost extends PostEvent {
  final Post post;

  const AddPost(this.post);

  @override
  List<Object?> get props => [post];
}

/// event to remove current user post
@immutable
class RemovePost extends PostEvent {
  final int id;

  const RemovePost(this.id);

  @override
  List<Object?> get props => [id];
}

/// increment post comment count
@immutable
class IncrementCommentCount extends PostEvent {
  final int postId;

  const IncrementCommentCount(this.postId);

  @override
  List<Object?> get props => [postId];
}

@immutable
class RemoveComment extends PostEvent {
  final int id;
  final int commentId;

  const RemoveComment(this.id, this.commentId);

  @override
  List<Object?> get props => [id];
}

/// increment post like count
@immutable
class IncrementReactionCount extends PostEvent {
  final int postId;

  const IncrementReactionCount(this.postId);

  @override
  List<Object?> get props => [];
}

@immutable
class Reset extends PostEvent {
  @override
  List<Object?> get props => [];
}
