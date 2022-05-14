import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:http/http.dart' as http;

import '../models/FileUpload.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class PostService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Post>> getStories({int? page, int? pageSize}) async {
    var url = Uri.parse(
        baseUrl + "/api/v1/member/stories?page=$page&pageSize=$pageSize");
    final resp = await http.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json"
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

  Future<List<Post>> getPosts({int? page, int? pageSize}) async {
    var url = Uri.parse(
        baseUrl + "/api/v1/member/posts?page=$page&pageSize=$pageSize");
    final resp = await http.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json"
    });
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = respBody['data'] as List<dynamic>;
      final rs =
          list.map((e) => Post.fromJson((e as Map<String, dynamic>))).toList();
      print(rs);
      return rs;
    }
    return [];
  }

  Future<List<Post>> getCurrentUserStories({int? page, int? pageSize}) async {
    var url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/stories?page=$page&pageSize=$pageSize");
    final resp = await http.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json"
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

  Future<List<Post>> getCurrentUserPosts({int? page, int? pageSize}) async {
    var url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/posts?page=$page&pageSize=$pageSize");
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

  Future<void> reactionPost(
      {required int postId, required int? reactionId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/reactions");
    final resp = await http.post(url,
        headers: {
          "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"postId": postId, "reactionId": reactionId}));
    if (resp.statusCode == 200) {
      print('reaction success');
    }
    print(resp.body.toString());
    return;
  }

  Future<Map<String, String>> authorizationHeader() async {
    return {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json",
    };
  }

  Future<Post> createPost(
      Map<String, dynamic> post, List<File> attachments) async {
    var url = Uri.parse(baseUrl + "/api/v1/member/users/me/posts");
    List<int> attachmentIds = [];
    if (attachments.isNotEmpty) {
      for (int i = 0; i < attachments.length; i++) {
        var resp = await uploadImage(attachments[i]);
        attachmentIds.add(resp.id);
      }
    }
    var accessToken = await _storage.read(key: 'accessToken');
    var body = <String, dynamic>{
      "id": post['id'],
      "caption": post['caption'].toString().trim(),
      "type": 1,
      "contents": attachmentIds
          .asMap()
          .entries
          .map((e) => {
                "attachmentId": e.value,
                "pos": e.key,
                "active": 1,
                "caption": post['caption'].toString().trim()
              })
          .toList(),
    };
    var resp = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken'
        },
        body: jsonEncode(body));
    if (resp.statusCode != 200) throw 'Could not create story';
    var jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
    final postResp = Post.fromJson(jsonBody['data']);
    print('Create post success');
    return postResp;
  }

  Future<FileUpload> uploadImage(File file) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/files");
    var request = http.MultipartRequest("POST", uri);

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $accessToken';
    var path = file.path;
    var f = http.MultipartFile.fromBytes('file', File(path).readAsBytesSync(),
        filename: basename(file.path), contentType: MediaType('image', 'jpeg'));

    request.files.add(f);
    final streamResp = await request.send();
    final resp = await http.Response.fromStream(streamResp);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      FileUpload fileUpload = FileUpload.fromJson(body['data']);
      return fileUpload;
    } else {
      throw 'Failed to upload images';
    }
  }
}
