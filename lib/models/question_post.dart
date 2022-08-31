import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/post_content.dart';
import 'package:traveling_social_app/models/tag.dart';

import 'user.dart';

QuestionPost postFromJson(String str) =>
    QuestionPost.fromJson(json.decode(str));

class QuestionPost with ChangeNotifier {
  int? id;
  String? caption;
  int? status;
  int? active;
  User? user;
  String? createDate;
  int likeCount = 0;
  int reactionCount = 0;
  int commentCount = 0;
  bool isClose = true;
  List<Tag> tags = [];

  QuestionPost.fromJson(dynamic json) {
    id = json['id'];
    caption = json['caption'];
    status = json['status'];
    active = json['active'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createDate = json['createDate'];
    likeCount = json['likeCount'] ?? 0;
    reactionCount = json['reactionCount'] ?? 0;
    commentCount = json['commentCount'] ?? 0;
    isClose = json['close'] ?? true;
    if (json['tags'] != null) {
      tags =
          (json['tags'] as List<dynamic>).map((t) => Tag.fromJson(t)).toList();
    }
  }

  @override
  String toString() {
    return '{id: $id, caption: $caption}';
  }

  QuestionPost({
    int? id,
    String? caption,
    int? status,
    int? active,
    User? user,
    List<Content>? contents,
    String? createDate,
    String? updateDate,
    int reactionCount = 0,
    int commentCount = 0,
    bool isClose = true,
    List<Tag> tags = const [],
  }) {
    id = id;
    caption = caption;
    status = status;
    active = active;
    user = user;
    contents = contents;
    createDate = createDate;
    updateDate = updateDate;
    reactionCount = reactionCount;
    commentCount = commentCount;
    isClose = isClose;
    tags = tags;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionPost &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
