part of 'creation_review_cubit.dart';

enum ReviewPostStatus {
  initial,
  success,
  loadingCoverImage,
  loadingImages,
  uploadingReview
}

class CreateReviewPostState {
  final CreationReviewPost post;
  final ReviewPostStatus status;

  const CreateReviewPostState(
      {this.post = const CreationReviewPost(),
      this.status = ReviewPostStatus.initial});

  CreateReviewPostState copyWith(
      {CreationReviewPost? post, ReviewPostStatus? status}) {
    return CreateReviewPostState(
        post: post ?? this.post, status: status ?? this.status);
  }
}
