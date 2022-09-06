import 'base_user.dart';

class TourUser {
  int? id;

  BaseUserInfo? user;

  String? createDate;

  String? rejectedDate;

  int? status;

  int? messageGroupId;

  TourUser(
      {this.id, this.user, this.createDate, this.status, this.rejectedDate,this.messageGroupId});

  TourUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
    createDate = json['createDate'];
    rejectedDate = json['rejectedDate'];
    status = json['status'];
    messageGroupId = json['messageGroupId'];
  }

  TourUser copyWithStatus({int? status}){
    return TourUser(
      id: id,
      status: status??this.status,
      createDate: createDate,
      messageGroupId: messageGroupId,
      rejectedDate: rejectedDate,
      user: user,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['createDate'] = createDate;
    data['rejectedDate'] = rejectedDate;
    data['status'] = status;
    data['messageGroupId'] = messageGroupId;
    return data;
  }
}
