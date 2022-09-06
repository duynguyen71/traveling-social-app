import 'package:traveling_social_app/models/location.dart';
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
    FileUpload? coverPhoto,
    List<ReviewPostAttachment> images = const [],
    List<Tag> tags = const [],
    BaseUserInfo? user,
    String? createDate,
    bool hasBookmark = false,
    Location? location,
    double? rating,
    double? myRating,
  }) {
    id = id;
    title = title;
    content = content;
    contentJson = contentJson;
    cost = cost;
    numOfParticipant = numOfParticipant;
    totalDay = totalDay;
    status = status;
    coverPhoto = coverPhoto;
    images = images;
    user = user;
    createDate = createDate;
    tags = tags;
    hasBookmark = hasBookmark;
    location = location;
    rating = rating;
    myRating=myRating;
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
    rating = json['rating'];
    myRating = json['myRating'];
    hasBookmark = json['hasBookmark'];
    coverPhoto = json['coverPhoto'] != null
        ? FileUpload.fromJson(json['coverPhoto'])
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
    location =
        json['location'] != null ? Location.fromMap(json['location']) : null;
  }

  int? id;
  String? title;
  String? content;
  String? contentJson;
  double? cost;
  int numOfParticipant = 1;
  int numOfReaction = 0;
  int numOfVisitor = 0;
  int numOfComment = 0;
  int? totalDay;
  int? status;
  FileUpload? coverPhoto;
  List<ReviewPostAttachment> images = [];
  List<Tag> tags = [];
  BaseUserInfo? user;
  String? createDate;
  bool hasBookmark = false;
  Reaction? myReaction;
  Location? location;
  double? rating;
  double? myRating;

  ReviewPostDetail copyWith({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    double? cost,
    int? numOfParticipant,
    int? totalDay,
    int? status,
    FileUpload? coverPhoto,
    List<ReviewPostAttachment> images = const [],
    List<Tag> tags = const [],
    BaseUserInfo? user,
    String? createDate,
    Location? location,
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
          coverPhoto: coverPhoto ?? this.coverPhoto,
          images: images,
          user: user ?? user,
          createDate: createDate ?? createDate,
          tags: tags,
          location: location ?? this.location);
}
