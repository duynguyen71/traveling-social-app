import 'dart:convert';

import 'package:flutter/cupertino.dart';

User afvFromJson(String str) => User.fromJson(json.decode(str));

String afvToJson(User data) => json.encode(data.toJson());

class User with ChangeNotifier {

  User({
    required int id,
    String? username,
    String? avt,
    required String email,
    int followerCounts = 0,
    int followingCounts = 0,
    bool isFollowed = false
  }) {
    _id = id;
    _username = username;
    avt = avt;
    _email = email;
    _followerCounts = followerCounts;
    _followingCounts = followingCounts;
    isFollowed = isFollowed;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    avt = json['avt'];
    _email = json['email'];
    _followerCounts = json['followerCounts'] ?? 0;
    _followingCounts = json['followingCounts'] ?? 0;
    _bio = json['bio'];
    background = json['background'];
    _createDate = json['createDate'];
    isFollowed = json['isFollowed']??false;
  }

  int? _id;
  String? _username;
  String? avt;
  String? _email;
  int _followerCounts = 0;
  int _followingCounts = 0;
  String? _bio;
  String? background;
  String? _createDate;
  bool isFollowed = false;

  int? get id => _id;

  String? get username => _username;


  String? get bio => _bio;

  String? get email => _email;

  int get followerCounts => _followerCounts;

  int get followingCounts => _followingCounts;

  String? get createDate => _createDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avt'] = avt;
    map['email'] = _email;
    map['followerCounts'] = _followerCounts;
    map['followingCounts'] = _followingCounts;
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
