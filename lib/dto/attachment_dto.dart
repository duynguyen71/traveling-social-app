import 'dart:io';

import 'package:equatable/equatable.dart';

class AttachmentDto extends Equatable {
  final int? id;

  final int? imageId;

  final String? path;

  final String? name;

  final int? pos;

  final int status;

  const AttachmentDto(
      {this.id, this.path, this.name, this.pos, this.imageId, this.status = 1});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['imageId'] = imageId;
    map['pos'] = pos;
    map['status'] = status;
    return map;
  }

  AttachmentDto copyWith({
    int? id,
    String? name,
    int? pos,
    String? path,
    int? imageId,
    int status = 1,
  }) =>
      AttachmentDto(
          id: id ?? this.id,
          name: name ?? this.name,
          pos: pos ?? this.pos,
          imageId: imageId ?? this.imageId,
          path: path ?? this.path,
          status: status);

  File get file {
    return File(path!);
  }

  @override
  List<Object?> get props => [id, name, pos, path, status];
}
