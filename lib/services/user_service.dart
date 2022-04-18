import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/User.dart';
import 'package:http/http.dart' as http;

class UserService {
  UserService() {
    _storage = const FlutterSecureStorage();
  }

  late final FlutterSecureStorage _storage;

  //login
  Future<Map<String, dynamic>> login(username, password) async {
    final resp = await http.post(Uri.parse(baseUrl + "/api/v1/auth/login"),
        headers: {
          "Content-Type": "application/json",
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode({'email': username, 'password': password}));
    final statusCode = resp.statusCode;
    if (statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      //save token to secure storage
      await _storage.write(key: 'accessToken', value: data['accessToken']);
      await _storage.write(key: 'refreshToken ', value: data['refreshToken']);
      print("Login success!");
      return data;
    }
    print("Failed to login!");
    throw 'Username or password not correct';
  }

  Future<User?> getCurrentUserInfo() async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      final resp =
          await http.get(Uri.parse(baseUrl + '/api/v1/member/users/me'));
      var statusCode = resp.statusCode;
      if (statusCode == 200) {
        final data = jsonDecode(resp.body);
        print(data);
      } else {
        //
      }
    }
    return null;
  }
}
