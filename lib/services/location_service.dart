import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:traveling_social_app/models/location.dart';

class LocationService {
  /// check location service enable
  Future<bool> checkPositionService() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    return true;
  }

  /// Determine the current position of the device.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Accessing the position of the device.
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Current user position: $position');
    return position;
  }

  checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<List<Location>> reverse(
      {required double latitude, required double longitude}) async {
    final url = Uri.parse('http://api.positionstack.com/v1/reverse?access_key='
        '$kPositionStackAPIKey'
        '&query=$latitude,$longitude'
        '&output=json'
        '&limit=30'
        '&fields=results.label,results.map_url');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      var data = body['data'] as List<dynamic>;
      var rs = data.map((location) => Location.fromMap(location)).toList();
      print('\n ${data.length} \n');
      return rs;
    } else {
      return [];
    }
  }

  Future<List<Location>> forward({required String query}) async {
    final url = Uri.parse('http://api.positionstack.com/v1/forward?access_key='
        '$kPositionStackAPIKey'
        '&query=$query'
        '&output=json'
        '&limit=10'
        '&fields=results.label,results.map_url');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      var data = body['data'] as List<dynamic>;
      var rs = data.map((location) => Location.fromMap(location)).toList();
      return rs;
    } else {
      print('Forward location failed: ${resp.body}');
      return [];
    }
  }
}
