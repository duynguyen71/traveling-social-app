import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/dto/attachment_dto.dart';
import 'package:traveling_social_app/dto/creation_review_post.dart';

import '../../models/tag.dart';
import '../../services/post_service.dart';

part 'creation_review_state.dart';

/// cubit for save creation review post
class CreateReviewPostCubit extends Cubit<CreateReviewPostState> {
  CreateReviewPostCubit() : super(const CreateReviewPostState());

  setReviewPost(CreationReviewPost creationReviewPost) {
    emit(CreateReviewPostState(
        post: creationReviewPost, status: ReviewPostStatus.initial));
  }

  clear() {
    emit(const CreateReviewPostState());
  }

  updateReviewPost({
    int? id,
    String? title,
    String? shortDescription,
    int? numOfParticipant,
    int? days,
    double? cost,
    String? content,
    String? contentJson,
    AttachmentDto? coverImage,
    List<AttachmentDto>? images,
    List<Tag>? tags,
  }) {
    emit(
      CreateReviewPostState(
        post: state.post.copyWith(
            id: id,
            content: content,
            title: title,
            cost: cost,
            days: days,
            contentJson: contentJson,
            numOfParticipant: numOfParticipant,
            shortDescription: shortDescription,
            coverPhoto: coverImage,
            images: images,
            tags: tags),
      ),
    );
  }

  updateStatus(ReviewPostStatus status) {
    emit(
      CreateReviewPostState(status: status, post: state.post),
    );
  }

  final _postService = PostService();

  uploadReview() async {
    try {
      emit(state.copyWith(status: ReviewPostStatus.uploadingReview));
      await _postService.createReviewPost(state.post);
      emit(state.copyWith(status: ReviewPostStatus.success));
    } on Exception catch (e) {
    } finally {
      // emit(
      //   state.copyWith(
      //     status: ReviewPostStatus.success,
      //     post: const CreationReviewPost(),
      //   ),
      // );
    }
  }
}
