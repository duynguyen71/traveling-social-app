import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

/// Base interceptor for http request
/// Using when user is authenticated
class BaseInterceptor implements InterceptorContract {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Triggering before the http request is called
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      var url = data.url;
      print('\nRequesting on: $url method ${data.method}\n');
      String? token = await _storage.read(key: 'accessToken');
      if (token != null) {
        data.headers['Authorization'] = "Bearer $token";
      }
      data.headers['Content-Type'] = "application/json";
      return data;
    } on Exception catch (e) {
      print('exception: $e');
    }
    return data;
  }
  /// Triggering after the request is called
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
