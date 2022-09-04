import 'dart:convert';

import 'package:equatable/equatable.dart';

String locationToJson(Location location) => jsonEncode(location.toJson());

class Location extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? region;
  final String? streetAddress;
  final int? streetNumber;
  final String? postal;
  final String? countryCode;
  final String? countryName;
  final int? postalCode;
  final String? name;
  final String? label;
  final String? county;
  final String? type;

  const Location(
      {this.longitude,
      this.latitude,
      this.county,
      this.type,
      this.city,
      this.countryCode,
      this.postalCode,
      this.countryName,
      this.postal,
      this.region,
      this.name,
      this.label,
      this.streetAddress,
      this.streetNumber});

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: (map['latitude']) ?? 0,
      longitude: (map['longitude'] ) ?? 0,
      city: map['region'],
      county: map['county'],
      type: map['type'],
      name: map['name'],
      label: map['label'],
      countryCode: map['country_code'],
      countryName: map['country'],
      postal: map['postalCode'],
      //city
      region: map['region'],
      streetAddress: map['street'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['region'] = name;
    map['city'] = name;
    map['countryCode'] = countryCode;
    map['countryName'] = countryName;
    map['postal'] = postal;
    map['region'] = region;
    map['name'] = name;
    map['label'] = label;
    map['streetAddress'] = streetAddress;
    map['streetNumber'] = streetNumber;
    return map;
  }

  @override
  bool get stringify {
    return true;
  }

  @override
  List<Object?> get props => [
        longitude,
        latitude,
        city,
        name,
        label,
        countryName,
        countryCode,
        postal,
        region,
        streetAddress,
        streetNumber
      ];
}
