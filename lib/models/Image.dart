class Image {
  Image({
      this.id, 
      this.name, 
      this.contentType, 
      this.createDate,});

  Image.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    contentType = json['contentType'];
    createDate = json['createDate'];
  }
  int? id;
  String? name;
  String? contentType;
  String? createDate;
Image copyWith({  int? id,
  String? name,
  String? contentType,
  String? createDate,
}) => Image(  id: id ?? this.id,
  name: name ?? this.name,
  contentType: contentType ?? this.contentType,
  createDate: createDate ?? this.createDate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['contentType'] = contentType;
    map['createDate'] = createDate;
    return map;
  }

}