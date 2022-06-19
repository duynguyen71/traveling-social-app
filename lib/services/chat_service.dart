import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/group.dart';
import 'package:http/http.dart' as http;
import 'package:traveling_social_app/models/message.dart';

class ChatService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Group>> getChatGroups() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/chat-groups");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final list = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      print(list);
      return list.map((json) => Group.fromJson(json)).toList();
    }
    print('get chat group failed');
    return [];
  }

  Future<Set<Message>> getMessages(int groupId,
      {int? page, int? pageSize, String? direction, String? sortBy}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/chat-groups/$groupId/messages?page=$page"
            "&pageSize=$pageSize"
            "&sortBy=$sortBy"
            "&direction=$direction");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      return data.map((e) => Message.fromJson(e)).toSet();
    }
    return <Message>{};
  }

  Future<Map<String, String>> authorizationHeader() async {
    return {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json",
    };
  }

  Future<String> getToken() async {
    return 'Bearer ${await _storage.read(key: 'accessToken')}';
  }
}
