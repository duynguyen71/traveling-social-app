import 'package:http_interceptor/http_interceptor.dart';

/// Expired token retry policy
class ExpiredTokenRetryPolicy extends RetryPolicy {
  /// Refresh token when token expired & http response status is unAuthorization 401
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    //Failed Authorization
    if (response.statusCode == 401) {
      // Perform your token refresh here.
      // refreshToken();
      return true;
    }
    return false;
  }
}
