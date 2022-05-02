import 'dart:convert';

FileUpload fileUploadFromJson(String str) =>
    FileUpload.fromJson(json.decode(str));

String fileUploadToJson(FileUpload data) => json.encode(data.toJson());

class FileUpload {
  FileUpload({
    required int id,
    required String name,
    required String contentType,
    required String uploadDate,
  }) {
    _id = id;
    _name = name;
    _contentType = contentType;
    _uploadDate = uploadDate;
  }

  FileUpload.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _contentType = json['contentType'];
    _uploadDate = json['uploadDate'];
  }

  late int _id;
  late String _name;
  late String _contentType;
  late String _uploadDate;

  int get id => _id;

  String get name => _name;

  String get contentType => _contentType;

  String get uploadDate => _uploadDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['contentType'] = _contentType;
    map['uploadDate'] = _uploadDate;
    return map;
  }
}
