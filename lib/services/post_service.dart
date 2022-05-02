import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:http/http.dart' as http;

class PostService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Post>> getPosts() async {
    var url = Uri.parse(baseUrl + "/api/v1/member/users/me/stories");
    final resp = await http.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
    });
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = respBody['data'] as List<dynamic>;
      final rs =
          list.map((e) => Post.fromJson((e as Map<String, dynamic>))).toList();
      return rs;
    }
    return [];
  }
}
