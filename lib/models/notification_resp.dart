import 'package:traveling_social_app/models/base_user.dart';


class NotificationResp {
  NotificationResp({
    this.id,
    this.message,
    this.createDate,
    this.user,
  });

  NotificationResp.fromJson(dynamic json) {
    id = json['id'];
    message = json['message'];
    createDate = json['createDate'];
    user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
  }

  int? id;
  String? message;
  String? createDate;
  BaseUserInfo? user;

  NotificationResp copyWith({
    int? id,
    String? message,
    String? createDate,
    BaseUserInfo? user,
  }) =>
      NotificationResp(
        id: id ?? this.id,
        message: message ?? this.message,
        createDate: createDate ?? this.createDate,
        user: user ?? this.user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['message'] = message;
    map['createDate'] = createDate;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}
