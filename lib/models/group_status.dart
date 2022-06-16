import 'package:traveling_social_app/models/base_user.dart';

class GroupStatus {
  BaseUserInfo? user;

  String? status;

  GroupStatus.fromJson(dynamic json) {
    status = json['status'] as String;
    user = BaseUserInfo.fromJson(json['user'] as Map<String, dynamic>);
  }
}
