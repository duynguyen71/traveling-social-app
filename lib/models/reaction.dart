/// id : 1
/// type : "LOVE"

class Reaction {
  Reaction({
    int? id,
    String? type,
  }) {
    _id = id;
    _type = type;
  }

  Reaction.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
  }
  int? _id;
  String? _type;

  int? get id => _id;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    return map;
  }
}
