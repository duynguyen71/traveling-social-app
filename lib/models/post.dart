import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/models/post_content.dart';
import 'package:traveling_social_app/models/reaction.dart';

import 'user.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

class Post with ChangeNotifier {
  int? id;
  String? caption;
  int? status;
  int? active;
  User? user;
  List<Content>? contents = [];
  String? createDate;
  String? updateDate;
  int likeCount = 0;
  int reactionCount = 0;
  int commentCount = 0;
  List<Comment> myComments = [];
  Reaction? myReaction;

  Post.fromJson(dynamic json) {
    id = json['id'];
    caption = json['caption'];
    status = json['status'];
    active = json['active'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['contents'] != null) {
      contents = [];
      json['contents'].forEach((v) {
        contents?.add(Content.fromJson(v));
      });
    }
    createDate = json['createDate'];
    updateDate = json['updateDate'];
    likeCount = json['likeCount'] ?? 0;
    reactionCount = json['reactionCount'] ?? 0;
    commentCount = json['commentCount'] ?? 0;

    Object? c = json['myComments'];
    myComments = c != null
        ? ((c as List<dynamic>).map((e) => Comment.fromJson(e)).toList())
        : [];

    var jsonReaction = json['myReaction'];
    myReaction = jsonReaction != null ? Reaction.fromJson(jsonReaction) : null;
  }

  @override
  String toString() {
    return '{id: $id, caption: $caption, contents : [$contents]}';
  }

  void copyWith({
    String? caption,
    int? status,
    int? active,
    User? user,
    List<Content>? contents,
    String? createDate,
    String? updateDate,
    int? reactionCount,
    int? commentCount,
  }) {
    reactionCount = reactionCount ?? this.reactionCount;
    commentCount = commentCount ?? this.commentCount;
  }

  Post({
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
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
