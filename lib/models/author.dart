import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Author extends Equatable {
  const Author(
      {this.id = -1,
      this.username = '',
      this.avt,
      this.numOfReviewPost = 0,
      this.numOfPost = 0,
      this.numOfFollower = 0,
      this.isFollowing = false});

  factory Author.empty() {
    return const Author();
  }

  factory Author.fromJson(dynamic json) {
    return Author(
        id: json['id'],
        username: json['username'],
        avt: json['avt'],
        numOfFollower: json['numOfFollower'],
        numOfPost: json['numOfPost'],
        numOfReviewPost: json['numOfReviewPost'],
        isFollowing: json['isFollowing']);
  }

  Author copyWith({bool? isFollowing}) {
    return Author(
        isFollowing: isFollowing ?? this.isFollowing,
        numOfReviewPost: numOfReviewPost,
        numOfPost: numOfReviewPost,
        numOfFollower: numOfFollower,
        avt: avt,
        id: id,
        username: username);
  }

  final int? id;
  final String? username;
  final String? avt;
  final int numOfReviewPost;
  final int numOfPost;
  final int numOfFollower;
  final bool isFollowing;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['avt'] = avt;
    map['numOfReviewPost'] = numOfReviewPost;
    map['numOfPost'] = numOfPost;
    map['numOfFollower'] = numOfFollower;
    map['isFollowing'] = isFollowing;
    return map;
  }

  @override
  List<Object?> get props => [id, isFollowing];
}
