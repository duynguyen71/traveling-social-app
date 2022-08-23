import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/base_user.dart';

class UpdateBaseUserInfo {
  UpdateBaseUserInfo(
      {this.username,
      this.fullName,
      this.birthdate,
      this.location,
      this.website,
      this.bio});

  String? username;
  String? fullName;
  String? birthdate;
  String? bio;
  String? website;
  String? location;

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {};
    map['username'] = username;
    map['fullName'] = fullName;
    map['birthdate'] = birthdate;
    map['bio'] = bio;
    map['website'] = website;
    map['location'] = location;
    return map;
  }
}
