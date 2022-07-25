class Notification {
  String? title;
  String? body;

  Notification(this.title, this.body);

  Notification.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
  }
}
