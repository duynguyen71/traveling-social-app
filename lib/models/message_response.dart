class MessageResponse {

  String? message;
  String? sendFrom;

  MessageResponse.fromJson(dynamic json) {
    // id = json['id'];
    message = json['message'];
    // status = json['status'];
    // user = json['user'] != null ? User.fromJson(json['user']) : null;
    // createDate = json['createDate'];
    // replyMessage = json['replyMessage'] != null ? Message.fromJson(json['replyMessage']) : null;
    sendFrom = json['sendFrom'];
  }
}