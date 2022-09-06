import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/post.dart';

import '../config/base_interceptor.dart';
import '../config/expired_token_retry.dart';
import '../dto/attachment_dto.dart';
import '../dto/creation_review_post.dart';
import '../models/Author.dart';
import '../models/Base_review_post_response.dart';
import '../models/Review_post_report.dart';
import '../models/base_tour.dart';
import '../models/comment.dart';
import '../models/current_user_tour.dart';
import '../models/file_upload.dart';
import '../models/question_post.dart';
import '../models/review_post_detail.dart';
import '../models/tag.dart';
import '../models/tour_detail.dart';
import '../models/tour_user.dart';
import '../widgets/tour.dart';

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
    final resp = await client.get(url);
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

  /// reaction emotion on review post
  Future<void> reactionReviewPost(
      {required int reviewPostId, required int? reactionId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/review-posts/reactions");
    final resp = await client.post(url,
        body: jsonEncode({"postId": reviewPostId, "reactionId": reactionId}));
    if (resp.statusCode == 200) {
      print('reaction review post $reviewPostId success');
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
      {required Map<String, dynamic> post,
      required List<File> attachments,
      int type = 1,
      Set<Tag> tags = const {}}) async {
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
      "type": type,
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
      "tags": tags.map((e) => e.toJson()).toList()
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
      print('upload image success');
      return fileUpload;
    } else {
      throw 'Failed to upload image';
    }
  }

  Future<void> hidePost({required int postId}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/posts/$postId/status/0");
    await client.put(url, headers: await authorizationHeader());
  }

  // Future<ReviewPostDetail?> getReviewPostDetail({required int id}) async {
  //   final url = Uri.parse(baseUrl + "/api/v1/member/reviews/$id");
  //   final resp = await client.get(url, headers: await authorizationHeader());
  //   if (resp.statusCode == 200) {
  //     final json = jsonDecode(resp.body) as Map<String, dynamic>;
  //     final data = json['data'] as Map<String, dynamic>;
  //     return ReviewPostDetail.fromJson(data);
  //   }
  //   return null;
  // }

  Future<List<Post>> getUserPosts(
      {required int userId, int? page = 0, int? pageSize = 5}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/users/$userId/posts?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final data = (jsonDecode(resp.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
      List<Post> posts = data.map((e) => Post.fromJson(e)).toList();
      return posts;
    }
    return [];
  }

  /// Get review posts
  Future<List<BaseReviewPostResponse>> getReviewPosts(
      {int? page, int? pageSize}) async {
    final url = Uri.parse(
        baseUrl + "/api/v1/member/review-posts?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;
      List<BaseReviewPostResponse> list =
          data.map((e) => BaseReviewPostResponse.fromJson(e)).toList();
      return list;
    }
    return [];
  }

  /// Get newest review posts
  Future<List<BaseReviewPostResponse>> getNewestReviewPost(
      {int? page, int? pageSize}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/review-posts/newest?page=$page&pageSize=$pageSize");
    final resp = await client.get(url, headers: await authorizationHeader());
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;
      List<BaseReviewPostResponse> list =
          data.map((e) => BaseReviewPostResponse.fromJson(e)).toList();
      return list;
    }
    return [];
  }

  /// Get review post detail
  Future<ReviewPostDetail?> getReviewPostDetail(int id) async {
    final url = Uri.parse('$baseUrl/api/v1/member/review-posts/$id');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      return ReviewPostDetail.fromJson(body['data']);
    }
    return null;
  }

  /// Create review post
  Future<void> createReviewPost(CreationReviewPost request) async {
    final url = Uri.parse('$baseUrl/api/v1/member/review-posts');
    //
    var requestJson = request.toJson();
    //upload cover image
    var coverImage = request.coverPhoto;
    if (coverImage?.id == null) {
      var coverImageResp = await uploadImage(coverImage!.file);
      requestJson['coverImageId'] = coverImageResp.id;
    } else {
      requestJson['coverImageId'] = request.coverPhoto?.id;
    }
    // upload images
    List<AttachmentDto> attachmentRequests = [];
    for (int i = 0; i < request.images.length; i++) {
      var attachmentRequest = request.images[i];
      //
      if (attachmentRequest.id == null && attachmentRequest.imageId == null) {
        var uploadResp = await uploadImage(attachmentRequest.file);
        attachmentRequest =
            attachmentRequest.copyWith(imageId: uploadResp.id, pos: i);
      } else {
        attachmentRequest = attachmentRequest.copyWith(pos: i);
      }
      attachmentRequests.add(attachmentRequest);
    }
    requestJson['images'] = attachmentRequests.map((e) => e.toJson()).toList();
    //
    final resp = await http.post(url,
        headers: await authorizationHeader(), body: jsonEncode(requestJson));
    if (resp.statusCode == 200) {
      return;
    } else {
      var body = jsonDecode(resp.body);
      print(body);
    }
  }

  /// Get review post root comments
  Future<Set<Comment>> getReviewPostComments(
      {required int postId, int page = 0, int pageSize = 100}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/review-posts/$postId/comments?$page=0&pageSize=$pageSize");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      var listComment = jsonBody['data'] as List<dynamic>;
      final data = listComment
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toSet();
      return data;
    }
    return {};
  }

  /// Get review post comment replies
  Future<Set<Comment>> getReviewPostReplyComment(
      {required int parentCommentId}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/review-posts/comments/$parentCommentId/reply");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      final listComment = jsonBody['data'] as List<dynamic>;
      var data = listComment
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toSet();
      return data;
    }
    return {};
  }

  Future<Author> getReviewPostAuthInfo({required int reviewPostId}) async {
    final url =
        Uri.parse('$baseUrl/api/v1/member/review-posts/$reviewPostId/auth');
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      return Author.fromJson(jsonDecode(resp.body)['data']);
    }
    return Author.empty();
  }

  /// Comment on review post
  Future<Comment> commentReviewPost(
      {int? postId,
      int? commentId,
      String? contentText,
      int? attachmentId,
      int? parentCommentId}) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/review-posts/$postId/comments");
    final resp = await client.post(
      url,
      body: jsonEncode(
        {
          "id": commentId,
          "postId": postId,
          "attachmentId": attachmentId,
          "parentCommentId": parentCommentId,
          "content": contentText,
        },
      ),
    );
    if (resp.statusCode == 200) {
      final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
      Comment comment =
          Comment.fromJson(jsonBody['data'] as Map<String, dynamic>);
      return comment;
    }
    throw 'Failed to post comment';
  }

  /// Hide comment on review posts
  Future<void> hideReviewPostComment({required int commentId}) async {
    final url = Uri.parse(
        baseUrl + "/api/v1/member/review-posts/comments/$commentId/status/0");

    final resp = await client.put(url);
    if (resp.statusCode == 200) {
      print('hide comment $commentId success');
    } else {
      print('hide comment failed' + resp.body);
    }
  }

  /// get tags
  Future<List<Tag>> getTags(
      {int page = 0, int pageSize = 100, String? name}) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/member/tags?name=$name&page=$page&pageSize=$pageSize');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var list = body['data'] as List<dynamic>;
      return list.map((e) => Tag.fromJson(e)).toList();
    }
    return [];
  }

  /// Get current user review posts report
  Future<List<ReviewPostReport>> getCurrentUserReviewPosts() async {
    final url = Uri.parse('$baseUrl/api/v1/member/users/me/review-posts');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var json = jsonDecode(resp.body) as Map<String, dynamic>;
      var data = json['data'] as List<dynamic>;
      return data.map((e) => ReviewPostReport.fromJson(e)).toList();
    }
    return [];
  }

  /// Get user fileuploads
  Future<List<FileUpload>> getUserFileUploads(userId,
      {int? page, int? pageSize}) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/member/users/$userId/file-uploads?page=$page&pageSize=$pageSize');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => FileUpload.fromJson(e)).toList();
    }
    return [];
  }

  /// Get current user review posts edit detail
  Future<CreationReviewPost?> getCurrentUserEditReviewPostDetail(int id) async {
    final url =
        Uri.parse('$baseUrl/api/v1/member/users/me/review-posts/$id/detail');
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      print(jsonDecode(resp.body));
      var creationReviewPost =
          CreationReviewPost.fromJson(jsonDecode(resp.body)['data']);
      print(creationReviewPost);
      return creationReviewPost;
    }
    return null;
  }

  /// Get bookmarks
  Future<List<BaseReviewPostResponse>> getBookmarkedReviewPosts(
      {int? page, int? pageSize}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/review-posts/bookmarks?page=$page&pageSize=$pageSize");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;
      List<BaseReviewPostResponse> list =
          data.map((e) => BaseReviewPostResponse.fromJson(e)).toList();
      print('Bookmark list size ${list.length}');
      return list;
    }
    return [];
  }

  /// Get bookmarks
  Future<bool> saveBookmark({int? postId}) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/review-posts/bookmarks/$postId");
    final resp = await client.post(url);
    if (resp.statusCode == 200) {
      print('Bookmark review post $postId success!');
      return true;
    }
    return false;
  }

  /// Remove bookmark
  Future<bool> removeBookmark(int id) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/review-posts/bookmarks/$id");
    final resp = await client.put(url);
    if (resp.statusCode == 200) return true;
    return false;
  }

  // Search review-post
  Future<List<BaseReviewPostResponse>> searchReviewPosts(key) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/review-posts/search?keyWord=$key");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => BaseReviewPostResponse.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<QuestionPost>> searchQuestions(key) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/posts/search?keyWord=$key&type=2");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => QuestionPost.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<QuestionPost>> getCurrentUserQuestionPosts() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/questions");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => QuestionPost.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<QuestionPost>> getQuestionPosts() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/questions");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var list = jsonDecode(resp.body)['data'] as List<dynamic>;
      return list.map((e) => QuestionPost.fromJson(e)).toList();
    }
    return [];
  }

  Future<QuestionPost?> getQuestionPostDetail(
      {required int questionPostId}) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/questions/$questionPostId/detail");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      var data = jsonDecode(resp.body)['data'] as Map<String, dynamic>;
      return QuestionPost.fromJson(data);
    }
    return null;
  }

  Future<void> closeCommentOnPost({required int postId, int status = 0}) async {
    final url = Uri.parse(
        baseUrl + "/api/v1/member/users/me/questions/$postId/close/$status");
    await client.put(url);
  }

  //TOUR

  Future<List<BaseTour>> getCurrentUserTours({int? page}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/tours?page=$page");
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = body['data'] as List<dynamic>;
      print('get user tour length ${list.length}');
      return list.map((e) => BaseTour.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BaseTour>> getTours({int? page}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/tours");
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      var list = body['data'] as List<dynamic>;
      return list.map((e) => BaseTour.fromJson(e)).toList();
    }
    return [];
  }

  Future<TourDetail?> getTourDetail({required int id}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/tours/$id");
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      var tour = TourDetail.fromJson(jsonDecode(resp.body)['data']);
      return tour;
    }
    return null;
  }

  Future<void> saveTour({required Tour tour}) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/tours");
    String jso = tourToJson(tour);
    final resp = await client.post(url, body: jso);
    if (resp.statusCode == 200) {
      print('save tour success');
      // print(jsonDecode(resp.body));
    }
  }

  Future<Tour?> getMyTourDetail(int id) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/tours/$id");
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      var tour = Tour.fromJson(jsonDecode(resp.body)['data']);
      print(tour);
      return tour;
    }

    return null;
  }

  Future<CurrentUserTour?> getCurrentTour() async {
    final url = Uri.parse(baseUrl + "/api/v1/member/users/me/tours/current");
    var resp = await client.get(url);
    if (resp.statusCode == 200) {
      var tour = CurrentUserTour.fromJson(jsonDecode(resp.body)['data']);
      print(tour);
      return tour;
    }
    return null;
  }

  Future<List<TourUser>> getTourUsers(int tourId) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/users/me/tours/$tourId/users");
    final resp = await client.get(url);
    if (resp.statusCode == 200) {
      final list = (jsonDecode(resp.body)['data']) as List<dynamic>;
      print("Tour users count ${list.length}");
      return list.map((e) => TourUser.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> closeTour(int tourId) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/users/me/tours/$tourId/close/0");
    final resp = await client.post(url);
    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> complete(int tourId) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/users/me/tours/$tourId/complete");
    final resp = await client.post(url);
    if (resp.statusCode == 200) {
      print('complete tour');
      return true;
    }
    return false;
  }

  Future<bool> leave(int tourId) async {
    final url = Uri.parse(baseUrl + "/api/v1/member/tours/$tourId/leave");
    final resp = await client.post(url);
    if (resp.statusCode == 200) {
      print('leave tour success');
      return true;
    }
    return false;
  }

  Future<bool> requestJoin(int tourId) async {
    final url =
        Uri.parse(baseUrl + "/api/v1/member/tours/$tourId/request-join");
    final resp = await client.post(url);
    if (resp.statusCode == 200) {
      print('request join success');
      return true;
    }
    print(resp.body);
    return false;
  }

  Future<bool> updateTourUserStatus({var tourUserId, var status}) async {
    final url = Uri.parse(baseUrl +
        "/api/v1/member/users/me/tours/users/$tourUserId/status/$status");
    final resp = await client.put(url);
    if (resp.statusCode == 200) {
      print('update status $status');
      return true;
    }
    return false;
  }
}
