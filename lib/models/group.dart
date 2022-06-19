import 'package:flutter/cupertino.dart';

import 'user.dart';
import 'message.dart';

class Group with ChangeNotifier {

  Group.fromJson(dynamic json) {
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
    map['name'] = name;
    map['users'] = users.map((v) => v.toJson()).toList();
    var lastMessageJson = map['lastMessage'];
    if (lastMessageJson != null) {
       lastMessage = Message.fromJson(lastMessageJson);
    }
    map['createDate'] = createDate;
    map['updateDate'] = updateDate;
    return map;
  }

  String get name {
    if (_name == null || _name.toString().trim().isEmpty) {
      String rs = '';
      for (int i = 0; i < users.length; i++) {
        rs += users[i].username.toString() +
            (i == users.length - 1 ? '' : ', ');
      }
      return rs;
    } else {
      return _name!;
    }
  }
}
