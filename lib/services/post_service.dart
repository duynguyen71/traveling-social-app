import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:traveling_social_app/models/review_post.dart';
import 'package:traveling_social_app/models/review_post_detail.dart';

import '../config/expired_token_retry.dart';
import '../config/base_interceptor.dart';
import '../models/file_upload.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

/// Service class for Posts
class PostService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Create base http client
  Client client = InterceptedClient.build(interceptors: [
    BaseInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  /// get friends stories
  Future<Set<Post>> getStories({int? page, int? pageSize}) async {
    var url = Uri.parse(
        baseUrl + "/api/v1/member/stories?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json"
    });
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = respBody['data'] as List<dynamic>;
      final rs =
          list.map((e) => Post.fromJson((e as Map<String, dynamic>))).toSet();
      return rs;
    }
    return <Post>{};
  }

  /// get friends posts
  Future<Set<Post>> getPosts({int? page, int? pageSize}) async {
    var url = Uri.parse(
        baseUrl + "/api/v1/member/posts?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json"
    });
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = respBody['data'] as List<dynamic>;
      final rs =
          list.map((e) => Post.fromJson((e as Map<String, dynamic>))).toSet();
      return rs;
    }
    return <Post>{};
  }

  /// Get current user stories
  Future<List<Post>> getCurrentUserStories({int? page, int? pageSize}) async {
    var url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/stories?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: {
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

  /// Get current user posts
  Future<List<Post>> getCurrentUserPosts(
      {int? page, int? pageSize, int? status}) async {
    var url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/posts?page=$page&pageSize=$pageSize&status=$status");
    final resp = await client.get(url, headers: {
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


  /// reaction emotion on post
  Future<void> reactionPost(
      {required int postId, required int? reactionId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/reactions");
    final resp = await client.post(url,
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

  /// Add story
  Future<Post> createStory(
      Map<String, dynamic> story, List<File> attachments) async {
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
      "id": story['id'],
      "caption": story['caption'].toString().trim(),
      "type": 0,
      "contents": attachmentIds
          .asMap()
          .entries
          .map((e) => {
        "attachment": {"id": e.value},
        "pos": e.key,
        "active": 1,
        "caption": story['caption'].toString().trim()
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
    final storyResp = Post.fromJson(jsonBody['data']);
    return storyResp;
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
                "attachment": {"id": e.value},
                "pos": e.key,
                "active": 1,
                "caption": post['caption'].toString().trim()
              })
          .toList(),
    };
    final resp = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken'
        },
        body: jsonEncode(body));
    if (resp.statusCode != 200) throw 'Could not create post';
    final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
    final postResp = Post.fromJson(jsonBody['data']);
    return postResp;
  }

  Future<FileUpload> uploadImage(File file) async {
    print('handle upload image');
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/file");
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
      throw 'Failed to upload image';
    }
  }

  Future<void> hidePost({required int postId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/$postId/status/0");
     await client.put(url, headers: await authorizationHeader());
  }

  Future<List<ReviewPost>> getReviewPosts() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/reviews");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;
      List<ReviewPost> list = data.map((e) => ReviewPost.fromJson(e)).toList();
      return list;
    }

    return [];
  }

  Future<ReviewPostDetail?> getReviewPostDetail({required int id}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/reviews/$id");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      return ReviewPostDetail.fromJson(data);
    }
    return null;
  }

  Future<List<Post>> getUserPosts(
      {required int userId, int? page = 0, int? pageSize = 5}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/users/$userId/posts?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      print('get user id $userId post success');
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      List<Post> posts = data.map((e) => Post.fromJson(e)).toList();
      return posts;
    }
    return [];
  }
}
