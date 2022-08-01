import 'package:equatable/equatable.dart';
import 'package:traveling_social_app/models/user.dart';

import 'message.dart';

class ChatGroupDetail extends Equatable {
  ChatGroupDetail.fromJson(dynamic json) {
    id = json['id'];
    _name = json['name'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(User.fromJson(v));
      });
    }
    lastMessage = json['lastMessage'] != null
        ? Message.fromJson(json['lastMessage'])
        : null;
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }

  int? id;
  String? _name;
  List<User> users = [];
  Message? lastMessage;
  String? createDate;
  String? updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = _name;
    map['users'] = users.map((v) => v.toJson()).toList();
    var lastMessageJson = map['lastMessage'];
    if (lastMessageJson != null) {
      lastMessage = Message.fromJson(lastMessageJson);
    }
    map['createDate'] = createDate;
    map['updateDate'] = updateDate;
    return map;
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify {
    return true;
  }
}
