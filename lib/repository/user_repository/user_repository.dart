import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/repository/authentication_repository/user.dart';

class UserRepository {
  User? _user;
  final _storage = const FlutterSecureStorage();

  Future<User?> getUser() async {
    final url = Uri.parse("$baseUrl/api/v1/member/users/me");
    try {
      final resp = await http.get(url, headers: {
        "Authorization": "Bearer ${await _storage.read(key: "accessToken")}"
      });
      if (resp.statusCode == 200) {
        _user = User.fromJson(jsonDecode(resp.body)['data']);
        return _user;
      }
      return null;
    } on Exception catch (e) {
      return null;
    }
  }
}
