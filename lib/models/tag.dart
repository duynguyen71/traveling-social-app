import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int? id;

  final String? name;

  final int? status;

  const Tag({this.id, this.name, this.status = 1});

  factory Tag.fromJson(Map json) {
    return Tag(id: json['id'], name: json['name']);
  }

  Tag copyWith({int? status}) {
    return Tag(id: id, name: name, status: status);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    return map;
  }

  @override
  List<Object?> get props => [name, status];
}
