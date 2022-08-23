import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      required this.username,
      required this.createDate,
      required this.followerCounts,
      required this.followingCounts,
      this.fullName,
      this.avt,
      this.bio,
      this.background,
      this.birthdate,
      this.website});

  final int id;
  final String username;
  final String? fullName;
  final String createDate;
  final int followingCounts;
  final int followerCounts;
  final String? avt;
  final String? bio;
  final String? background;
  final String? website;
  final String? birthdate;

  factory User.fromJson(dynamic json) {
    return User(
        id: json['id'],
        username: json['username'],
        fullName: json['fullName'],
        createDate: json['createDate'],
        followerCounts: json['followingCounts'] ?? 0,
        followingCounts: json['followerCounts'] ?? 0,
        avt: json['avt'],
        bio: json['bio'],
        website: json['website'],
        birthdate: json['birthdate'],
        background: json['background']);
  }

  static const empty = User(
      id: -1,
      username: '-',
      followingCounts: -1,
      followerCounts: -1,
      createDate: '-');

  /// Using to change user info when updated
  User copyWith({
    String? username,
    String? bio,
    String? email,
    String? avt,
    String? website,
    String? background,
    String? birthdate,
    String? fullName,
  }) {
    return User(
        id: id,
        username: username ?? this.username,
        createDate: createDate,
        bio: bio ?? this.bio,
        avt: avt ?? this.avt,
        background: background ?? this.background,
        followerCounts: followerCounts,
        followingCounts: followingCounts,
        birthdate: birthdate ?? this.birthdate,
        website: website ?? this.website,
        fullName: fullName ?? this.fullName);
  }

  @override
  List<Object?> get props =>
      [id, username, fullName, avt, bio, background, birthdate];

  @override
  bool get stringify => true;
}
