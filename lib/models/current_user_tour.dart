import 'package:equatable/equatable.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/models/location.dart';
import 'package:traveling_social_app/models/tour_user.dart';

class CurrentUserTour extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final int? numOfMember;
  final double? cost;
  final int? totalDay;
  final int? joinedMember;
  final Location? location;
  final String? departureDate;
  final BaseUserInfo? host;
  final int? numOfRequest;
  final List<TourUser> tourUsers;

  CurrentUserTour(
      {this.id,
      this.title,
      this.content,
      this.numOfMember,
      this.cost,
      this.totalDay,
      this.joinedMember,
      this.location,
      this.departureDate,
      this.numOfRequest,
      this.tourUsers = const [],
      this.host});

  CurrentUserTour copyWith({
    String? title,
    String? content,
    int? numOfRequest,
    int? numOfMember,
    double? cost,
    int? totalDay,
    int? joinedMember,
    Location? location,
    String? departureDate,
    List<TourUser>? tourUsers,
    BaseUserInfo? host,
  }) {
    return CurrentUserTour(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        numOfMember: numOfMember ?? this.numOfMember,
        cost: cost ?? this.cost,
        totalDay: totalDay ?? this.totalDay,
        joinedMember: joinedMember ?? this.joinedMember,
        location: location ?? this.location,
        departureDate: departureDate ?? this.departureDate,
        numOfRequest: numOfRequest ?? this.numOfRequest,
        tourUsers: tourUsers ?? this.tourUsers,
        host: host ?? this.host);
  }

  factory CurrentUserTour.fromJson(Map<String, dynamic> json) {
    var json2 = (json['users'] as List<dynamic>);
    return CurrentUserTour(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      numOfMember: json['numOfMember'],
      cost: json['cost'],
      totalDay: json['totalDay'],
      joinedMember: json['joinedMember'],
      numOfRequest: json['numOfRequest'],
      location:
          json['location'] != null ? Location.fromMap(json['location']) : null,
      departureDate: json['departureDate'],
      host: json['host'] != null ? BaseUserInfo.fromJson(json['host']) : null,
      tourUsers: json2.isNotEmpty
          ? json2.map((e) => TourUser.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['numOfMember'] = numOfMember;
    data['cost'] = cost;
    data['totalDay'] = totalDay;
    data['numOfRequest'] = numOfRequest;
    data['joinedMember'] = joinedMember;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['departureDate'] = departureDate;
    if (host != null) {
      data['host'] = host!.toJson();
    }
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        cost,
        totalDay,
        joinedMember,
        numOfRequest,
        numOfMember,
        location,
        tourUsers
      ];
}
