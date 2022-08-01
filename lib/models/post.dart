import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/comment.dart';
import 'package:traveling_social_app/models/reaction.dart';
import 'package:traveling_social_app/models/post_content.dart';

import 'user.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

class Post with ChangeNotifier {
  int? _id;
  String? _caption;
  int? _status;
  int? _active;
  User? _user;
  List<Content>? _contents = [];
  String? _createDate;
  String? _updateDate;
  int _likeCount = 0;
  int _reactionCount = 0;
  int _commentCount = 0;
  List<Comment> _myComments = [];
  Reaction? _myReaction;

  Post.fromJson(dynamic json) {
    _id = json['id'];
    _caption = json['caption'];
    _status = json['status'];
    _active = json['active'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['contents'] != null) {
      _contents = [];
      json['contents'].forEach((v) {
        _contents?.add(Content.fromJson(v));
      });
    }
    _createDate = json['createDate'];
    _updateDate = json['updateDate'];
    _likeCount = json['likeCount'] ?? 0;
    _reactionCount = json['reactionCount'] ?? 0;
    _commentCount = json['commentCount'] ?? 0;

    Object? c = json['myComments'];
    _myComments = c != null
        ? ((c as List<dynamic>).map((e) => Comment.fromJson(e)).toList())
        : [];

    var jsonReaction = json['myReaction'];
    _myReaction = jsonReaction != null ? Reaction.fromJson(jsonReaction) : null;
  }

  int? get id => _id;

  String? get caption => _caption;

  int? get status => _status;

  int? get active => _active;

  User? get user => _user;

  List<Content>? get contents => _contents;

  String? get createDate => _createDate;

  String? get updateDate => _updateDate;

  int get likeCounts => _likeCount;

  int get reactionCount => _reactionCount;

  int get commentCount => _commentCount;

  List<Comment> get myComments => _myComments;

  Reaction? get myReaction => _myReaction;

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
    _reactionCount = reactionCount ?? this.reactionCount;
    _commentCount = commentCount ?? this.commentCount;
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
    _id = id;
    _caption = caption;
    _status = status;
    _active = active;
    _user = user;
    _contents = contents;
    _createDate = createDate;
    _updateDate = updateDate;
    _reactionCount = reactionCount;
    _commentCount = commentCount;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  set commentCount(int i) => _commentCount = i;
}
