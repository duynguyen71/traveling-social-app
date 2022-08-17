import 'file_upload.dart';

class ReviewPostReport {
  ReviewPostReport({
    this.id,
    this.title,
    this.coverPhoto,
    this.numOfVisitor,
    this.numOfComment,
    this.numOfLike,
    this.createDate,
    this.updateDate,
  });

  ReviewPostReport.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    coverPhoto = json['coverPhoto'] != null
        ? FileUpload.fromJson(json['coverPhoto'])
        : null;
    numOfVisitor = json['numOfVisitor'];
    numOfComment = json['numOfComment'];
    numOfLike = json['numOfLike'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }

  int? id;
  String? title;
  FileUpload? coverPhoto;
  int? numOfVisitor;
  int? numOfComment;
  int? numOfLike;
  String? createDate;
  String? updateDate;

  ReviewPostReport copyWith({
    int? id,
    String? title,
    FileUpload? coverPhoto,
    int? numOfVisitor,
    int? numOfComment,
    int? numOfLike,
    String? createDate,
    String? updateDate,
  }) =>
      ReviewPostReport(
        id: id ?? this.id,
        title: title ?? this.title,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        numOfVisitor: numOfVisitor ?? this.numOfVisitor,
        numOfComment: numOfComment ?? this.numOfComment,
        numOfLike: numOfLike ?? this.numOfLike,
        createDate: createDate ?? this.createDate,
        updateDate: updateDate ?? this.updateDate,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    if (coverPhoto != null) {
      map['coverPhoto'] = coverPhoto?.toJson();
    }
    map['numOfVisitor'] = numOfVisitor;
    map['numOfComment'] = numOfComment;
    map['numOfLike'] = numOfLike;
    map['createDate'] = createDate;
    return map;
  }
}
