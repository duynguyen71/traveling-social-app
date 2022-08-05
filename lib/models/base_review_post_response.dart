import 'package:traveling_social_app/models/base_user.dart';

import 'file_upload.dart';

class BaseReviewPostResponse {
  BaseReviewPostResponse({
    this.id,
    this.title,
    this.content,
    this.coverImage,
    this.user,
    this.createDate,
  });

  BaseReviewPostResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    coverImage = json['coverImage'] != null
        ? FileUpload.fromJson(json['coverImage'])
        : null;
    user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
    createDate = json['createDate'];
  }

  int? id;
  String? title;
  String? content;
  FileUpload? coverImage;
  BaseUserInfo? user;
  String? createDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    if (coverImage != null) {
      map['coverImage'] = coverImage?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['createDate'] = createDate;
    return map;
  }
}
