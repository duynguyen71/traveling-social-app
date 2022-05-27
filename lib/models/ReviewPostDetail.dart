import 'package:traveling_social_app/models/Attachment.dart';

import 'User.dart';

class ReviewPostDetail {
  ReviewPostDetail({
      String? title, 
      String? detail, 
      double? cost, 
      int? totalMember, 
      int? totalDay, 
      int? status, 
      Attachment? coverPhoto,
      List<Attachment>? photos,
      User? user, 
      String? createDate,}){
    _title = title;
    _detail = detail;
    _cost = cost;
    _totalMember = totalMember;
    _totalDay = totalDay;
    _status = status;
    _coverPhoto = coverPhoto;
    _photos = photos;
    _user = user;
    _createDate = createDate;
}

  ReviewPostDetail.fromJson(dynamic json) {
    _title = json['title'];
    _detail = json['detail'];
    _cost = json['cost'];
    _totalMember = json['totalMember'];
    _totalDay = json['totalDay'];
    _status = json['status'];
    _coverPhoto = json['coverPhoto'] != null ? Attachment.fromJson(json['coverPhoto']) : null;
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos?.add(Attachment.fromJson(v));
      });
    }
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _createDate = json['createDate'];
  }
  String? _title;
  String? _detail;
  double? _cost;
  int? _totalMember;
  int? _totalDay;
  int? _status;
  Attachment? _coverPhoto;
  List<Attachment>? _photos;
  User? _user;
  String? _createDate;

  String? get title => _title;
  String? get detail => _detail;
  double? get cost => _cost;
  int? get totalMember => _totalMember;
  int? get totalDay => _totalDay;
  int? get status => _status;
  Attachment? get coverPhoto => _coverPhoto;
  List<Attachment>? get photos => _photos;
  User? get user => _user;
  String? get createDate => _createDate;

}