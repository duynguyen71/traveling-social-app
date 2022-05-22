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
    int? followerCounts,
    int? followingCounts,
  }) {
    _id = id;
    _username = username;
    _avt = avt;
    _email = email;
    _followerCounts = followerCounts;
    _followingCounts = followingCounts;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avt = json['avt'];
    _email = json['email'];
    _followerCounts = json['followerCounts'];
    _followingCounts = json['followingCounts'];
    _bio = json['bio'];
    _background = json['background'];
    _createDate = json['createDate'];
  }

  int? _id;
  String? _username;
  String? _avt;
  String? _email;
  int? _followerCounts;
  int? _followingCounts;
  String? _bio;
  String? _background;
  String? _createDate;

  int? get id => _id;

  String? get username => _username;

  String? get avt => _avt;

  String? get background => _background;

  String? get bio => _bio;

  String? get email => _email;

  int? get followerCounts => _followerCounts;

  int? get followingCounts => _followingCounts;

  String? get createDate => _createDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avt'] = _avt;
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

  set avt(String? avt) {
    _avt = avt;
  }

  set background(String? bg) {
    _background = bg;
  }
}
