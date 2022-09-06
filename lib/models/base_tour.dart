import 'tag.dart';

class BaseTour {
  int? id;
  String? title;
  String? content;
  int? numOfMember;
  int? joinedMember;
  String? createDate;
  List<Tag>? tags;

  BaseTour(
      {this.id,
      this.title,
      this.content,
      this.numOfMember,
      this.joinedMember,
      this.createDate,
      this.tags});

  BaseTour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    numOfMember = json['numOfMember'];
    joinedMember = json['joinedMember'];
    createDate = json['createDate'];
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
  }
}
