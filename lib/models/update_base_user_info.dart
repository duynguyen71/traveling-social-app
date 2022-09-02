import 'package:traveling_social_app/models/location.dart';

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
  Location? location;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['username'] = username;
    map['fullName'] = fullName;
    map['birthdate'] = birthdate;
    map['bio'] = bio;
    map['website'] = website;
    map['location'] = location;
    return map;
  }

  UpdateBaseUserInfo copyWith({
    String? username,
    String? fullName,
    String? birthdate,
    String? bio,
    String? website,
    Location? location,
  }) {
    return UpdateBaseUserInfo(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      birthdate: birthdate ?? this.birthdate,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      location: location ?? this.location,
    );
  }
}
