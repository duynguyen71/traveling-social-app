import 'dart:convert';

BaseUserInfo userFromJson(String str) =>
    BaseUserInfo.fromJson(json.decode(str));

String userToJson(BaseUserInfo data) => json.encode(data.toJson());

class BaseUserInfo {
  BaseUserInfo(
      {int? id, String? username, String? avt, bool isFollowing = false}) {
    _id = id;
    _username = username;
    _avt = avt;
    _isFollowing = isFollowing;
  }

  BaseUserInfo.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avt = json['avt'];
    _isFollowing = json['isFollowing'] ?? false;
  }

  int? _id;
  String? _username;
  String? _avt;
  bool _isFollowing = false;

  BaseUserInfo copyWith({
    int? id,
    String? username,
    String? avt,
  }) =>
      BaseUserInfo(
        id: id ?? _id,
        username: username ?? _username,
        avt: avt ?? _avt,
      );

  int? get id => _id;

  String? get username => _username;

  String? get avt => _avt;

  bool get isFollowing => _isFollowing;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avt'] = _avt;
    map['isFollowing'] = _isFollowing;
    return map;
  }
}
