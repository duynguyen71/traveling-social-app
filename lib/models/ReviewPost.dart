import 'package:traveling_social_app/models/Attachment.dart';
import 'package:traveling_social_app/models/BaseUserInfo.dart';

import 'User.dart';

class ReviewPost {
  ReviewPost({
    int? id,
    String? title,
    Attachment? coverPhoto,
    BaseUserInfo? user,
    String? createDate,
  }) {
    _id = id;
    _title = title;
    _coverPhoto = coverPhoto;
    _user = user;
    _createDate = createDate;
  }

  ReviewPost.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _coverPhoto = json['coverPhoto'] != null
        ? Attachment.fromJson(json['coverPhoto'])
        : null;
    _user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
    _createDate = json['createDate'];
  }

  int? _id;
  String? _title;
  Attachment? _coverPhoto;
  BaseUserInfo? _user;
  String? _createDate;

  int? get id => _id;

  String? get title => _title;

  Attachment? get coverPhoto => _coverPhoto;

  BaseUserInfo? get user => _user;

  String? get createDate => _createDate;
}
