import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.createDate,
    required this.followerCounts,
    required this.followingCounts,
    this.avt,
    this.bio,
    this.background,
  });

  final int id;
  final String username;
  final String createDate;
  final int followingCounts;
  final int followerCounts;
  final String? avt;
  final String? bio;
  final String? background;

  factory User.fromJson(dynamic json) {
    return User(
        id: json['id'],
        username: json['username'],
        createDate: json['createDate'],
        followerCounts: json['followingCounts'] ?? 0,
        followingCounts: json['followerCounts'] ?? 0,
        avt: json['avt'],
        bio: json['bio'],
        background: json['background']);
  }

  static const empty = User(
      id: -1,
      username: '-',
      followingCounts: -1,
      followerCounts: -1,
      createDate: '-');

  User copyWith(
      {String? username,
      String? bio,
      String? email,
      String? avt,
      String? background}) {
    return User(
        id: id,
        username: username ?? this.username,
        createDate: createDate,
        bio: bio ?? this.bio,
        avt: avt ?? this.avt,
        background: background ?? this.background,
        followerCounts: followerCounts,
        followingCounts: followingCounts);
  }

  @override
  List<Object?> get props => [id, username, avt, bio, background];

  @override
  bool get stringify => true;
}
