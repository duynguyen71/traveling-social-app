
import 'dart:convert';

BaseUserInfo userFromJson(String str) => BaseUserInfo.fromJson(json.decode(str));
String userToJson(BaseUserInfo data) => json.encode(data.toJson());
class BaseUserInfo {
  BaseUserInfo({
    int? id,
    String? username,
    String? avt,}) {
    _id = id;
    _username = username;
    _avt = avt;
  }

  BaseUserInfo.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avt = json['avt'];
  }

  int? _id;
  String? _username;
  String? _avt;

  BaseUserInfo copyWith({ int? id,
    String? username,
    String? avt,
  }) =>
      BaseUserInfo(id: id ?? _id,
        username: username ?? _username,
        avt: avt ?? _avt,
      );

  int? get id => _id;

  String? get username => _username;

  String? get avt => _avt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avt'] = _avt;
    return map;
  }
}