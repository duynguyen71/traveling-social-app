import 'dart:convert';

import 'base_user.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  int? id;
  String? content;
  BaseUserInfo? user;
  BaseUserInfo? replyUser;
  String? createDate;
  int? replyCount;
  List<Comment> replies = [];

  Comment(
      {this.id,
      this.content,
      this.user,
      this.createDate,
      this.replyCount,
      this.replies = const []});

  Comment.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    if (json['user'] != null) {
      user = BaseUserInfo.fromJson(json['user'] as Map<String, dynamic>);
    }
    if (json['replyUser'] != null) {
      replyUser =
          BaseUserInfo.fromJson(json['replyUser'] as Map<String, dynamic>);
    }
    createDate = json['createDate'];
    replyCount = json['replyCount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['content'] = content;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['createDate'] = createDate;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Comment copyWith({
    int? id,
    String? content,
    BaseUserInfo? user,
    String? createDate,
  }) =>
      Comment(
        id: id ?? id,
        content: content ?? content,
        user: user ?? user,
        createDate: createDate ?? createDate,
      );

  @override
  String toString() {
    return '\n{id: $id; content: $content; user: ${user?.username}}\n';
  }
}
