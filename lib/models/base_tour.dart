import 'package:traveling_social_app/models/location.dart';

import 'tag.dart';

class BaseTour {
  int? id;
  String? title;
  String? content;
  int? numOfMember;
  int? joinedMember;
  String? createDate;
  List<Tag>? tags;
  Location? location;

  BaseTour(
      {this.id,
      this.title,
      this.content,
      this.numOfMember,
      this.joinedMember,
      this.createDate,
      this.location,
      this.tags});

  BaseTour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    numOfMember = json['numOfMember'];
    joinedMember = json['joinedMember'];
    createDate = json['createDate'];
    location =
        json['location'] != null ? Location.fromMap(json['location']) : null;
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
  }
}
