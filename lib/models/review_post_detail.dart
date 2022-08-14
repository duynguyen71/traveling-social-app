import 'package:traveling_social_app/models/reaction.dart';
import 'package:traveling_social_app/models/tag.dart';

import 'Review_post_attachment.dart';
import 'base_user.dart';
import 'file_upload.dart';

class ReviewPostDetail {
  ReviewPostDetail({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    double? cost,
    int? numOfParticipant,
    int? totalDay,
    int? status,
    FileUpload? coverImage,
    List<ReviewPostAttachment> images = const [],
    List<Tag> tags = const [],
    BaseUserInfo? user,
    String? createDate,
    bool hasBookmark = false,
  }) {
    id = id;
    title = title;
    content = content;
    contentJson = contentJson;
    cost = cost;
    numOfParticipant = numOfParticipant;
    totalDay = totalDay;
    status = status;
    coverImage = coverImage;
    images = images;
    user = user;
    createDate = createDate;
    tags = tags;
    hasBookmark = hasBookmark;
  }

  ReviewPostDetail.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    contentJson = json['contentJson'];
    cost = json['cost'];
    numOfParticipant = json['numOfParticipant'];
    numOfReaction = json['numOfReaction'];
    numOfComment = json['numOfComment'];
    numOfVisitor = json['numOfVisitor'];
    totalDay = json['totalDay'];
    status = json['status'];
    hasBookmark = json['hasBookmark'];
    coverImage = json['coverImage'] != null
        ? FileUpload.fromJson(json['coverImage'])
        : null;
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(ReviewPostAttachment.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      var list = (json['tags'] as List);
      tags = list.map((item) => Tag.fromJson(item)).toList();
    }
    user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
    createDate = json['createDate'];
    myReaction =
        json['reaction'] != null ? Reaction.fromJson(json['reaction']) : null;
  }

  int? id;
  String? title;
  String? content;
  String? contentJson;
  double? cost;
  int numOfParticipant = 0;
  int numOfReaction = 0;
  int numOfVisitor = 0;
  int numOfComment = 0;
  int? totalDay;
  int? status;
  FileUpload? coverImage;
  List<ReviewPostAttachment> images = [];
  List<Tag> tags = [];
  BaseUserInfo? user;
  String? createDate;
  bool hasBookmark = false;
  Reaction? myReaction;

  ReviewPostDetail copyWith({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    double? cost,
    int? numOfParticipant,
    int? totalDay,
    int? status,
    FileUpload? coverImage,
    List<ReviewPostAttachment> images = const [],
    List<Tag> tags = const [],
    BaseUserInfo? user,
    String? createDate,
  }) =>
      ReviewPostDetail(
          id: id ?? this.id,
          title: title ?? this.title,
          content: content ?? this.content,
          contentJson: contentJson ?? this.contentJson,
          cost: cost ?? this.cost,
          numOfParticipant: numOfParticipant ?? this.numOfParticipant,
          totalDay: totalDay ?? this.totalDay,
          status: status ?? this.status,
          coverImage: coverImage ?? this.coverImage,
          images: images,
          user: user ?? user,
          createDate: createDate ?? createDate,
          tags: tags);

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['id'] = id;
//   map['title'] = title;
//   map['content'] = content;
//   map['contentJson'] = contentJson;
//   map['cost'] = cost;
//   map['numOfParticipant'] = numOfParticipant;
//   map['totalDay'] = totalDay;
//   map['status'] = status;
//   if (coverImage != null) {
//     map['coverImage'] = coverImage?.toJson();
//   }
//   map['images'] = images.map((v) => v.toJson()).toList();
//   if (user != null) {
//     map['user'] = user?.toJson();
//   }
//   map['createDate'] = createDate;
//   map['tags'] = tags.map((e) => e.toJson()).toList();
//   return map;
// }
}
