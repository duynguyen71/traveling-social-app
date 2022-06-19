import 'package:flutter/cupertino.dart';

import 'user.dart';

class Message with ChangeNotifier {
  Message({
    this.id,
    this.message,
    this.status,
    this.user,
    this.createDate,
    this.replyMessage,
  });

  Message.fromJson(dynamic json) {
    id = json['id'];
    message = json['message'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createDate = json['createDate'];
    replyMessage = json['replyMessage'] != null
        ? Message.fromJson(json['replyMessage'])
        : null;
  }

  int? id;
  String? message;
  int? status;
  User? user;
  String? createDate;
  Message? replyMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['message'] = message;
    map['status'] = status;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['createDate'] = createDate;
    if (replyMessage != null) {
      map['replyMessage'] = replyMessage?.toJson();
    }
    return map;
  }

// @override
// bool operator ==(Object other) =>
//     identical(this, other) ||
//     other is Message && runtimeType == other.runtimeType && id == other.id;
//
// @override
// int get hashCode => id.hashCode;
}
