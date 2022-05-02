import 'dart:convert';

import 'Attachment.dart';

Contents contentsFromJson(String str) => Contents.fromJson(json.decode(str));
String contentsToJson(Contents data) => json.encode(data.toJson());
class Contents {
  Contents({
    int? id,
    String? caption,
    Attachment? attachment,
    String? createDate,
    String? updateDate,}){
    _id = id;
    _caption = caption;
    _attachment = attachment;
    _createDate = createDate;
    _updateDate = updateDate;
  }

  Contents.fromJson(dynamic json) {
    _id = json['id'];
    _caption = json['caption'];
    _attachment = json['attachment'] != null ? Attachment.fromJson(json['attachment']) : null;
    _createDate = json['createDate'];
    _updateDate = json['updateDate'];
  }
  int? _id;
  String? _caption;
  Attachment? _attachment;
  String? _createDate;
  String? _updateDate;
  Contents copyWith({  int? id,
    String? caption,
    Attachment? attachment,
    String? createDate,
    String? updateDate,
  }) => Contents(  id: id ?? _id,
    caption: caption ?? _caption,
    attachment: attachment ?? _attachment,
    createDate: createDate ?? _createDate,
    updateDate: updateDate ?? _updateDate,
  );
  int? get id => _id;
  String? get caption => _caption;
  Attachment? get attachment => _attachment;
  String? get createDate => _createDate;
  String? get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['caption'] = _caption;
    if (_attachment != null) {
      map['attachment'] = _attachment?.toJson();
    }
    map['createDate'] = _createDate;
    map['updateDate'] = _updateDate;
    return map;
  }

  @override
  String toString() {
    return '{id: $id, attachment: $attachment, caption: $caption}';
  }

}
