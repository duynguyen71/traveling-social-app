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
      await saveToken(data);
      print("Login success!");
      return data;
    }
    print("Failed to login!");
    throw 'Username or password not correct';
  }

  Future<void> saveToken(Map<String, dynamic> data) async {
    await _storage.write(key: 'accessToken', value: data['accessToken']);
    await _storage.write(key: 'refreshToken ', value: data['refreshToken']);
  }

  Future<User?> getCurrentUserInfo() async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      final resp = await http.get(
          Uri.parse(baseUrl + '/api/v1/member/users/me'),
          headers: {"Authorization": 'Bearer $accessToken'});
      final statusCode = resp.statusCode;
      if (statusCode == 200) {
        final jsonData = jsonDecode(resp.body) as Map<String, dynamic>;
        User user = User.fromJson(jsonData['data']);
        print('get current user success');
        return user;
      } else {
        print('failed to get user info');
        print(jsonDecode(resp.body));
        return null;
      }
    }
    return null;
  }

  Future<void> register(
      {required String username,
      required String email,
      required String password}) async {
    final uri = Uri.parse(baseUrl + '/api/v1/public/users/registration');
    final resp = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }));
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    var statusCode = resp.statusCode;
    if (statusCode == 400) {
      String? errMsg = body['message'];
      throw errMsg ?? 'Some thing went wrong!';
    }
    return;
  }

  void signOut() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  //validate user input @return String error message
  Future<String?> checkValidationInput(
      {required String input, required String value}) async {
    final url = Uri.parse(
        baseUrl + '/api/v1/public/validation-input?input=$input&value=$value');
    final resp = await http.get(url);
    final statusCode = resp.statusCode;
    if (statusCode == 200) return null;
    final bodyJson = jsonDecode(resp.body);
    return bodyJson['message'];
  }

  Future<void> verifyAccount({required String code}) async {
    final url = Uri.parse(baseUrl + "/api/v1/auth/verification");
    final resp = await http.get(url, headers: {"code": code});
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final tokens = body['data'];
      await saveToken(tokens);
      return;
    } else {
      throw 'Code is not valid';
    }
  }
}
