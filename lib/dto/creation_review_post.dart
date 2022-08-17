import 'package:equatable/equatable.dart';

import '../models/tag.dart';
import 'attachment_dto.dart';

class CreationReviewPost extends Equatable {
  final int? id;
  final String? title;
  final String? shortDescription;
  final int? numOfParticipant;
  final int? totalDay;
  final double? cost;
  final String? content;
  final String? contentJson;
  final AttachmentDto? coverPhoto;
  final List<AttachmentDto> images;
  final List<Tag> tags;
  final int status;

  factory CreationReviewPost.fromJson(dynamic json) {
    return CreationReviewPost(
      id: json['id'],
      content: json['content'],
      contentJson: json['contentJson'],
      title: json['title'],
      cost: json['cost'],
      numOfParticipant: json['numOfParticipant'],
      totalDay: json['totalDay'],
      status: json['status'],
      coverPhoto: json['coverPhoto'] != null
          ? AttachmentDto.fromJson(json['coverPhoto'])
          : null,
      images: json["images"] != null
          ? (json['images'] as List<dynamic>)
              .map((i) => AttachmentDto.fromJson(i))
              .toList()
          : [],
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>).map((t) => Tag.fromJson(t)).toList()
          : [],
    );
  }

  const CreationReviewPost(
      {this.id,
      this.title,
      this.shortDescription,
      this.numOfParticipant = 1,
      this.totalDay = 1,
      this.content,
      this.coverPhoto,
      this.status = 1,
      this.contentJson,
      this.images = const [],
      this.tags = const [],
      this.cost = 0});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['cost'] = cost;
    map['numOfParticipant'] = numOfParticipant;
    map['shortDescription'] = shortDescription;
    map['content'] = content;
    map['contentJson'] = contentJson;
    map['totalDay'] = totalDay;
    map['status'] = status;
    map['tags'] = tags;
    return map;
  }

  CreationReviewPost copyWith(
          {int? id,
          String? title,
          String? shortDescription,
          int? numOfParticipant,
          int? days,
          double? cost,
          List<AttachmentDto>? images,
          String? content,
          AttachmentDto? coverPhoto,
          String? contentJson,
          List<Tag>? tags}) =>
      CreationReviewPost(
          id: id ?? this.id,
          title: title ?? this.title,
          shortDescription: shortDescription ?? this.shortDescription,
          numOfParticipant: numOfParticipant ?? this.numOfParticipant,
          totalDay: days ?? this.totalDay,
          cost: cost ?? this.cost,
          coverPhoto: coverPhoto ?? this.coverPhoto,
          images: images ?? this.images,
          tags: tags ?? this.tags,
          contentJson: contentJson ?? this.contentJson,
          content: content ?? this.content);

  @override
  List<Object?> get props => [id, coverPhoto, images];
}
