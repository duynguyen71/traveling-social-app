
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/models/file_upload.dart';

import 'Review_post_attachment.dart';

class ReviewPostDetails {
  ReviewPostDetails({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    double? cost,
    int? numOfParticipant,
    int? totalDay,
    int? status,
    FileUpload? coverImage,
    List<ReviewPostAttachment>? images,
    BaseUserInfo? user,
    String? createDate,
  }) {
    _id = id;
    _title = title;
    _content = content;
    _contentJson = contentJson;
    _cost = cost;
    _numOfParticipant = numOfParticipant;
    _totalDay = totalDay;
    _status = status;
    _coverImage = coverImage;
    _images = images;
    _user = user;
    _createDate = createDate;
  }

  ReviewPostDetails.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _content = json['content'];
    _contentJson = json['contentJson'];
    _cost = json['cost'];
    _numOfParticipant = json['numOfParticipant'];
    _totalDay = json['totalDay'];
    _status = json['status'];
    _coverImage = json['coverImage'] != null
        ? FileUpload.fromJson(json['coverImage'])
        : null;
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(ReviewPostAttachment.fromJson(v));
      });
    }
    _user = json['user'] != null ? BaseUserInfo.fromJson(json['user']) : null;
    _createDate = json['createDate'];
  }

  int? _id;
  String? _title;
  String? _content;
  String? _contentJson;
  double? _cost;
  int? _numOfParticipant;
  int? _totalDay;
  int? _status;
  FileUpload? _coverImage;
  List<ReviewPostAttachment>? _images;
  BaseUserInfo? _user;
  String? _createDate;

  ReviewPostDetails copyWith({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    double? cost,
    int? numOfParticipant,
    int? totalDay,
    int? status,
    FileUpload? coverImage,
    List<ReviewPostAttachment>? images,
    BaseUserInfo? user,
    String? createDate,
  }) =>
      ReviewPostDetails(
        id: id ?? _id,
        title: title ?? _title,
        content: content ?? _content,
        contentJson: contentJson ?? _contentJson,
        cost: cost ?? _cost,
        numOfParticipant: numOfParticipant ?? _numOfParticipant,
        totalDay: totalDay ?? _totalDay,
        status: status ?? _status,
        coverImage: coverImage ?? _coverImage,
        images: images ?? _images,
        user: user ?? _user,
        createDate: createDate ?? _createDate,
      );

  int? get id => _id;

  String? get title => _title;

  String? get content => _content;

  String? get contentJson => _contentJson;

  double? get cost => _cost;

  int? get numOfParticipant => _numOfParticipant;

  int? get totalDay => _totalDay;

  int? get status => _status;

  FileUpload? get coverImage => _coverImage;

  List<ReviewPostAttachment> get images => _images != null ? _images! : [];

  BaseUserInfo? get user => _user;

  String? get createDate => _createDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['content'] = _content;
    map['contentJson'] = _contentJson;
    map['cost'] = _cost;
    map['numOfParticipant'] = _numOfParticipant;
    map['totalDay'] = _totalDay;
    map['status'] = _status;
    if (_coverImage != null) {
      map['coverImage'] = _coverImage?.toJson();
    }
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['createDate'] = _createDate;
    return map;
  }
}
