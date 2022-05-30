import 'dart:convert';

import 'package:flutter/cupertino.dart';

User afvFromJson(String str) => User.fromJson(json.decode(str));

String afvToJson(User data) => json.encode(data.toJson());

class User with ChangeNotifier {

  User.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    avt = json['avt'];
    email = json['email'];
    followerCounts = json['followerCounts'] ?? 0;
    followingCounts = json['followingCounts'] ?? 0;
    bio = json['bio'];
    background = json['background'];
    createDate = json['createDate'];
    isFollowed = json['isFollowed']??false;
  }

  int? id;
  String? username;
  String? avt;
  String? email;
  int followerCounts = 0;
  int followingCounts = 0;
  String? bio;
  String? background;
  String? createDate;
  bool isFollowed = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['avt'] = avt;
    map['email'] = email;
    map['followerCounts'] = followerCounts;
    map['followingCounts'] = followingCounts;
    return map;
  }

  @override
  String toString() {
    return '{id: $id, username: $username, avt: $avt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;


}
