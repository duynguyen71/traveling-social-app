import 'package:equatable/equatable.dart';

import '../models/tag.dart';
import 'attachment_dto.dart';

class CreationReviewPost extends Equatable {
  final int? id;
  final String? title;
  final String? shortDescription;
  final int? numOfParticipants;
  final int? days;
  final double? cost;
  final String? content;
  final String? contentJson;
  final AttachmentDto? coverImage;
  final List<AttachmentDto> images;
  final List<Tag> tags;

  const CreationReviewPost(
      {this.id,
      this.title,
      this.shortDescription,
      this.numOfParticipants = 1,
      this.days = 1,
      this.content,
      this.coverImage,
      this.contentJson,
      this.images = const [],
      this.tags = const [],
      this.cost = 0});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['cost'] = cost;
    map['numOfParticipant'] = numOfParticipants;
    map['shortDescription'] = shortDescription;
    map['content'] = content;
    map['contentJson'] = contentJson;
    map['tags'] = tags;
    return map;
  }

  CreationReviewPost copyWith({
    int? id,
    String? title,
    String? shortDescription,
    int? numOfParticipants,
    int? days,
    double? cost,
    List<AttachmentDto>? images,
    String? content,
    AttachmentDto? coverImage,
    String? contentJson,
    List<Tag>? tags
  }) =>
      CreationReviewPost(
          id: id ?? this.id,
          title: title ?? this.title,
          shortDescription: shortDescription ?? this.shortDescription,
          numOfParticipants: numOfParticipants ?? this.numOfParticipants,
          days: days ?? this.days,
          cost: cost ?? this.cost,
          coverImage: coverImage ?? this.coverImage,
          images: images ?? this.images,
          tags: tags ?? this.tags,
          contentJson: contentJson ?? this.contentJson,
          content: content ?? this.content);

  @override
  List<Object?> get props => [id, coverImage, images];
}
