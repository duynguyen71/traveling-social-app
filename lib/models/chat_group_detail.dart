import 'package:equatable/equatable.dart';

import 'base_user.dart';
import 'message.dart';

class ChatGroupDetail extends Equatable {
  ChatGroupDetail.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(BaseUserInfo.fromJson(v));
      });
    }
    lastMessage = json['lastMessage'] != null
        ? Message.fromJson(json['lastMessage'])
        : null;
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }

  ChatGroupDetail copyWith({String? name,Message? lastMessage,List<BaseUserInfo>? users}) {
    return ChatGroupDetail(
        id: id,
        name: name ?? this.name,
        createDate: createDate,
        lastMessage: lastMessage?? this.lastMessage,
        updateDate: updateDate,
        users:users?? this.users);
  }

  ChatGroupDetail(
      {this.id,
      this.name,
      this.users = const [],
      this.lastMessage,
      this.createDate,
      this.updateDate});

  int? id;
  String? name;
  List<BaseUserInfo> users = [];
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

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify {
    return true;
  }
}
