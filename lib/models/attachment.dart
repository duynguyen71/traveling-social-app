import 'dart:convert';

Attachment attachmentFromJson(String str) =>
    Attachment.fromJson(json.decode(str));
String attachmentToJson(Attachment data) => json.encode(data.toJson());

class Attachment {
  Attachment({
    int? id,
    String? name,
    String? contentType,
    String? uploadDate,
  }) {
    _id = id;
    _name = name;
    _contentType = contentType;
    _uploadDate = uploadDate;
  }

  Attachment.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _contentType = json['contentType'];
    _uploadDate = json['uploadDate'];
  }
  int? _id;
  String? _name;
  String? _contentType;
  String? _uploadDate;
  Attachment copyWith({
    int? id,
    String? name,
    String? contentType,
    String? uploadDate,
  }) =>
      Attachment(
        id: id ?? _id,
        name: name ?? _name,
        contentType: contentType ?? _contentType,
        uploadDate: uploadDate ?? _uploadDate,
      );
  int? get id => _id;
  String? get name => _name;
  String? get contentType => _contentType;
  String? get uploadDate => _uploadDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['contentType'] = _contentType;
    map['uploadDate'] = _uploadDate;
    return map;
  }

  @override
  String toString() {
    return '{id : $id, name: $name, contentType: $contentType}';
  }
}
