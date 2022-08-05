import 'file_upload.dart';

class ReviewPostAttachment {
  ReviewPostAttachment({
    this.id,
    this.image,
    this.status,
    this.pos,
  });

  ReviewPostAttachment.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'] != null ? FileUpload.fromJson(json['image']) : null;
    status = json['status'];
    pos = json['pos'];
  }

  int? id;
  FileUpload? image;
  int? status;
  int? pos;

  ReviewPostAttachment copyWith({
    int? id,
    FileUpload? image,
    int? status,
    int? pos,
  }) =>
      ReviewPostAttachment(
        id: id ?? this.id,
        image: image ?? this.image,
        status: status ?? this.status,
        pos: pos ?? this.pos,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (image != null) {
      map['image'] = image?.toJson();
    }
    map['status'] = status;
    map['pos'] = pos;
    return map;
  }
}
