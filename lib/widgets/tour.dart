import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../models/location.dart';
import '../models/tag.dart';

String tourToJson(Tour tour) => json.encode(tour.toJson());

class Tour extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final int? numOfMember;
  final double? cost;
  final String? departureDate;
  final String? createDate;
  final List<Tag>? tags;
  final Location? location;
  final int? totalDay;

  const Tour({
    this.id,
    this.title,
    this.content,
    this.numOfMember,
    this.createDate,
    this.tags,
    this.cost,
    this.totalDay,
    this.location,
    this.departureDate,
  });

  Tour copyWith({
    int? id,
    String? title,
    String? content,
    int? numOfMember,
    double? cost,
    String? departureDate,
    String? createDate,
    List<Tag>? tags,
    Location? location,
    int? totalDay,
  }) {
    return Tour(
        id: id ?? this.id,
        location: location ?? this.location,
        totalDay: totalDay ?? this.totalDay,
        content: content ?? this.content,
        cost: cost ?? this.cost,
        title: title ?? this.title,
        departureDate: departureDate ?? this.departureDate,
        numOfMember: numOfMember ?? this.numOfMember,
        tags: tags ?? this.tags);
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    List<Tag> t = const [];
    if (json['tags'] != null) {
      t = <Tag>[];
      json['tags'].forEach((v) {
        t.add(Tag.fromJson(v));
      });
    }
    Location? loc;
    if (json['location'] != null) {
      loc = (Location.fromMap(json['location']));
    }
    return Tour(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        numOfMember: json['numOfMember'],
        cost: json['cost'],
        departureDate: json['departureDate'],
        totalDay: json['totalDay'],
        createDate: json['createDate'],
        tags: t,
        location: loc);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    map['tags'] = tags;
    map['location'] = location;
    map['totalDay'] = totalDay;
    map['numOfMember'] = numOfMember;
    map['cost'] = cost;
    map['departureDate'] = departureDate;
    return map;
  }

  @override
  List<Object?> get props =>
      [id, content, title, location, cost, totalDay, numOfMember, tags];
}
