import 'dart:convert';
import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/models/file_upload.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/models/update_base_user_info.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

import '../config/base_interceptor.dart';
import '../config/expired_token_retry.dart';
import '../models/Notification_resp.dart';
import '../models/chat_group_detail.dart';
import '../models/create_chat_group.dart';
import '../models/group.dart';
import '../models/location.dart';
import '../models/message.dart';

class UserService {
  UserService() {
    _storage = const FlutterSecureStorage();
  }

  late final FlutterSecureStorage _storage;

  // Create base http client
  Client client = InterceptedClient.build(interceptors: [
    BaseInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  Future<void> saveToken(Map<String, dynamic> data) async {
    await _storage.write(key: 'accessToken', value: data['accessToken']);
    await _storage.write(key: 'refreshToken ', value: data['refreshToken']);
  }

  Future<User?> getCurrentUserInfo() async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      try {
        final resp = await http.get(
            Uri.parse(baseUrl + '/api/v1/member/users/me'),
            headers: {"Authorization": 'Bearer $accessToken'});
        final statusCode = resp.statusCode;
        if (statusCode == 200) {
          final jsonData = jsonDecode(resp.body) as Map<String, dynamic>;
          User user = User.fromJson(jsonData['data']);
          return user;
        }
      } on SocketException {
        return null;
      }
    }
    return null;
  }

  /// Update base user info
  Future<bool> updateBaseUserInfo(UpdateBaseUserInfo info) async {
    print('handle update user');
    final url = Uri.parse("$baseUrl/api/v1/member/users/me");
    final resp = await client.put(url, body: jsonEncode(info.toJson()));
    if (resp.statusCode == 200) {
      print('Update user info success');
      return true;
    }
    return false;
  }

  Future<User?> getUserDetail({required int userId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/$userId");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      return User.fromJson(data);
    }
    print(jsonDecode(resp.body));
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
    if (statusCode == 200) {
      return;
    }
    String? errMsg = body['message'];
    throw errMsg ?? 'Some thing went wrong!';
  }

  void signOut() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  //validate user input @return String error message
  Future<String?> checkValidationInput(
      {required String input, required String? value}) async {
    final url = Uri.parse(
        baseUrl + '/api/v1/public/validation-input?input=$input&value=$value');
    final resp = await http.get(url);
    final statusCode = resp.statusCode;
    if (statusCode == 200) return null;
    final bodyJson = jsonDecode(resp.body);
    return bodyJson['message'];
  }

  Future<Map<String, dynamic>> verifyAccount({required String code}) async {
    final url = Uri.parse(baseUrl + "/api/v1/auth/verification");
    final resp = await http.get(url, headers: {"code": code});
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      Map<String, dynamic> tokens = body['data'];
      return tokens;
    } else {
      throw 'Code is not valid';
    }
  }

  Future<FileUpload> uploadImage(File file) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/file");
    var request = http.MultipartRequest("POST", uri);

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $accessToken';
    var path = file.path;
    var f = http.MultipartFile.fromBytes('file', File(path).readAsBytesSync(),
        filename: basename(file.path), contentType: MediaType('image', 'jpeg'));

    request.files.add(f);
    try {
      final streamResp = await request.send();
      final resp = await http.Response.fromStream(streamResp);
      if (resp.statusCode == 200) {
        var body = jsonDecode(resp.body) as Map<String, dynamic>;
        FileUpload fileUpload = FileUpload.fromJson(body['data']);
        return fileUpload;
      } else {
        print('server response' + jsonDecode(resp.body).toString());
        throw 'Failed to upload images ';
      }
    } on Exception catch (e) {
      throw 'Failed to upload images ' + e.toString();
    }
  }

  Future<List<FileUpload>> uploadFiles(List<File> file) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/files");
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    return [];
  }

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
    print('Create story success');
    return storyResp;
  }

  Future<void> getFollowingFriendStories() async {}

  Future<Map<String, String>> getHeader() async {
    var accessToken = await _storage.read(key: 'accessToken');
    return {
      "Authorization": 'Bearer $accessToken',
      "Content-Type": 'application/json',
    };
  }

  Future<FileUpload> updateAvt({required File file}) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/avt");
    var request = http.MultipartRequest("PUT", uri);

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
      print('update avt success');
      return fileUpload;
    } else {
      throw 'Failed to upload images';
    }
  }

  Future<FileUpload> updateBackground({required File file}) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse(baseUrl + "/api/v1/member/users/me/background");
    var request = http.MultipartRequest("PUT", uri);

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
      print('update background success');
      return fileUpload;
    } else {
      throw 'Failed to upload background';
    }
  }

  Future<List<BaseUserInfo>> searchUsers(
      {String? username,
      String? email,
      String? phone,
      int? page,
      int? pageSize}) async {
    final url = Uri.parse(
        baseUrl + "/api/v1/member/users/searching?username=$username");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;
      return data.map((e) => BaseUserInfo.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, String>> authorizationHeader() async {
    return {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json",
    };
  }

  Future<List<BaseUserInfo>> getTopActiveUsers() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      var list = json.map((u) => BaseUserInfo.fromJson(u)).toList();
      return list;
    }
    return [];
  }

  Future<bool> follow({required int userId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/follow/$userId");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      print("Follow user id $userId success!");
      return true;
    }
    print('Failed to follow user');
    return false;
  }

  Future<bool> unFollow({required int userId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/unfollow/$userId");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      print("Unfollow user id $userId success!");
      return true;
    }
    print('Failed to unfollow user');
    return false;
  }

  Future<void> refreshDeviceToken({required String token}) async {}

  /// Get notifications
  Future<List<NotificationResp>> getNotifications() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/notifications");
    final resp = await http.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => NotificationResp.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> getNotificationMessage() async {}

  // Get following
  Future<List<BaseUserInfo>> getFollowing({int? page, int? pageSize}) async {
    final url = Uri.parse(
        "$baseUrl/api/v1/member/users/me/following?page=$page&pageSize=$pageSize");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => BaseUserInfo.fromJson(e)).toList();
    }
    return [];
  } // Get followr

  Future<List<BaseUserInfo>> getFollower({int? page, int? pageSize}) async {
    final url = Uri.parse(
        "$baseUrl/api/v1/member/users/me/followers?page=$page&pageSize=$pageSize");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      print(list);
      return list.map((e) => BaseUserInfo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Group>> getChatGroups({int? page, int? pageSize}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/chat-groups?page=$page&pageSize=$pageSize");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final list = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      return list.map((json) => Group.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> leaveGroup({required int groupId}) async {
    final url = Uri.parse(
        baseUrl + "/api/v1/member/users/me/chat-groups/$groupId/leave");
    final resp = await client.put(url);
    if (resp.statusCode == 200) {
      print('leave group $groupId success');
      return true;
    }
    return false;
  }

  Future<Set<Message>> getMessages(int groupId,
      {int? page, int? pageSize, String? direction, String? sortBy}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/chat-groups/$groupId/messages?page=$page"
            "&pageSize=$pageSize"
            "&sortBy=$sortBy"
            "&direction=$direction");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      return data.map((e) => Message.fromJson(e)).toSet();
    }
    return <Message>{};
  }

  /// get chat group between two user
  Future<Group?> getChatGroupBetweenTwoUsers(userId) async {
    final url =
        Uri.parse('$baseUrl/api/v1/member/users/me/chat-groups/users/$userId');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      var group = Group.fromJson(data);
      print(data);
      return group;
    } else {
      final data = (jsonDecode(resp.body));
      print(data);
    }
    return null;
  }

  Future<ChatGroupDetail?> getChatGroupDetail(int groupId) async {
    final url =
        Uri.parse('$baseUrl/api/v1/member/users/me/chat-groups/$groupId');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      var group = ChatGroupDetail.fromJson(data);
      return group;
    }
    return null;
  }

  Future<int?> createChatGroupWithNames(
      {String? groupName, required List<String> names}) async {
    final url =
        Uri.parse('$baseUrl/api/v1/member/users/me/chat-groups/member-names');
    final resp = await client.post(url,
        body: jsonEncode({"name": groupName, "names": names}));
    if (resp.statusCode == 200) {
      print('create chat group success');
      var data = jsonDecode(resp.body)['data'] as Map<String, dynamic>;
      print(data);
      return data['id'] as int;
    }
    print(jsonDecode(resp.body));
    return null;
  }

  Future<void> updateToken(token) async {
    await FkUserAgent.init();
    var ua = FkUserAgent.userAgent;
    final url = Uri.parse('$baseUrl/api/v1/member/users/me/devices/token');
    await http.post(url, headers: {
      "Authorization": 'Bearer ${await _storage.read(key: 'accessToken')}',
      "Content-Type": "application/json",
      "pnt": token,
      "User-Agent": '$ua'
    });
  }

  Future<void> forgetPasswordRequest() async {}

  Future<void> updateLocation(Location location) async {
    print('update user location');
    final url = Uri.parse('$baseUrl/api/v1/member/users/me/location');
    try {
      final resp = await client.post(url, body: locationToJson(location));
      if (resp.statusCode == 200) {
        print('update location success');
      } else {
        print(resp.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
