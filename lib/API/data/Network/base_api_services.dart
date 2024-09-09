abstract class BaseApiServices {
  Future<dynamic> getApi(String url);
  Future<dynamic> postApi(dynamic data, String url);
  Future<dynamic> postApiWithHeaders(
      dynamic data, String url, Map<String, String>? headers);
}
