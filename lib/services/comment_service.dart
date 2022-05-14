import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/models/Comment.dart';

import '../constants/api_constants.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Comment>> getRootCommentsOnPost({required int postId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/$postId/comments");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      final listComment = jsonBody['data'] as List<dynamic>;
      var data = listComment
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
      return data;
    }
    return [];
  }

  Future<List<Comment>> getReplyComment({required int parentCommentId}) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/comments/$parentCommentId/reply");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      final listComment = jsonBody['data'] as List<dynamic>;
      var data = listComment
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
      print(data);
      return data;
    }
    return [];
  }

  Future<Comment> commentPost(
      {int? postId,
      int? commentId,
      String? contentText,
      int? attachmentId,
      int? parentCommentId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/$postId/comments");
    final resp = await http.post(url,
        headers: await authorizationHeader(),
        body: jsonEncode({
          "id": commentId,
          "postId": postId,
          "attachmentId": attachmentId,
          "parentCommentId": parentCommentId,
          "content": contentText,
        }));
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      Comment comment =
          Comment.fromJson(jsonBody['data'] as Map<String, dynamic>);
      return comment;
    }
    throw 'Failed to post comment';
  }

  Future<Map<String, String>> authorizationHeader() async {
    return {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json",
    };
  }
}
