import 'dart:convert';

import 'package:traveling_social_app/models/User.dart';

import 'BaseUserInfo.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    int? id,
    String? content,
    User? user,
    String? createDate,
  }) {
    _id = id;
    _content = content;
    _user = user;
    _createDate = createDate;
  }

  Comment.fromJson(dynamic json) {
    _id = json['id'];
    _content = json['content'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _createDate = json['createDate'];
    _replyCount = json['replyCount'];
  }

  int? _id;
  String? _content;
  User? _user;
  String? _createDate;
  int? _replyCount;

  int? get id => _id;

  String? get content => _content;

  User? get user => _user;

  String? get createDate => _createDate;

  int? get replyCount => _replyCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['content'] = _content;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['createDate'] = _createDate;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  set content(String? t) {
    _content = t;
  }

  set id(int? t) {
    _id = t;
  }

  Comment copyWith({
    int? id,
    String? content,
    User? user,
    String? createDate,
  }) =>
      Comment(
        id: id ?? _id,
        content: content ?? _content,
        user: user ?? _user,
        createDate: createDate ?? _createDate,
      );
}
