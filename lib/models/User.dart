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

  // User.coppy(User user) {
  //   _id = user.id;
  //   _username = user.username;
  //   _avt = user.avt;
  //   _email = user.email;
  //   _followerCounts = user.followerCounts;
  //   _followingCounts = user.followingCounts;
  //   notifyListeners();
  // }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avt = json['avt'];
    _email = json['email'];
    _followerCounts = json['followerCounts'];
    _followingCounts = json['followingCounts'];
  }

  int? _id;
  String? _username;
  String? _avt;
  String? _email;
  int? _followerCounts;
  int? _followingCounts;

  int? get id => _id;

  String? get username => _username;

  String? get avt => _avt;

  String? get email => _email;

  int? get followerCounts => _followerCounts;

  int? get followingCounts => _followingCounts;

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
}
