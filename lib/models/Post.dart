import 'dart:convert';

import 'Attachment.dart';
import 'Content.dart';
import 'User.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    int? id,
    String? caption,
    int? status,
    int? active,
    User? user,
    List<Contents>? contents,
    String? createDate,
    String? updateDate,
    int? likeCounts,}) {
    _id = id;
    _caption = caption;
    _status = status;
    _active = active;
    _user = user;
    _contents = contents;
    _createDate = createDate;
    _updateDate = updateDate;
    _likeCounts = likeCounts;
  }

  Post.fromJson(dynamic json) {
    _id = json['id'];
    _caption = json['caption'];
    _status = json['status'];
    _active = json['active'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['contents'] != null) {
      _contents = [];
      json['contents'].forEach((v) {
        _contents?.add(Contents.fromJson(v));
      });
    }
    _createDate = json['createDate'];
    _updateDate = json['updateDate'];
    _likeCounts = json['likeCounts'];
  }

  int? _id;
  String? _caption;
  int? _status;
  int? _active;
  User? _user;
  List<Contents>? _contents;
  String? _createDate;
  String? _updateDate;
  int? _likeCounts;

  Post copyWith({ int? id,
    String? caption,
    int? status,
    int? active,
    User? user,
    List<Contents>? contents,
    String? createDate,
    String? updateDate,
    int? likeCounts,
  }) =>
      Post(
        id: id ?? _id,
        caption: caption ?? _caption,
        status: status ?? _status,
        active: active ?? _active,
        user: user ?? _user,
        contents: contents ?? _contents,
        createDate: createDate ?? _createDate,
        updateDate: updateDate ?? _updateDate,
        likeCounts: likeCounts ?? _likeCounts,
      );

  int? get id => _id;

  String? get caption => _caption;

  int? get status => _status;

  int? get active => _active;

  User? get user => _user;

  List<Contents>? get contents => _contents;

  String? get createDate => _createDate;

  String? get updateDate => _updateDate;

  int? get likeCounts => _likeCounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['caption'] = _caption;
    map['status'] = _status;
    map['active'] = _active;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_contents != null) {
      map['contents'] = _contents?.map((v) => v.toJson()).toList();
    }
    map['createDate'] = _createDate;
    map['updateDate'] = _updateDate;
    map['likeCounts'] = _likeCounts;
    return map;
  }

  @override
  String toString() {
    return '{id: $id, caption: $caption, contents : [$contents]}';
  }

}

