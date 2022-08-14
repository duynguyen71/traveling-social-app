import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int? id;

  final String? name;

  const Tag({this.id, this.name});

  factory Tag.fromJson(Map json) {
    return Tag(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  @override
  List<Object?> get props => [name];
}
