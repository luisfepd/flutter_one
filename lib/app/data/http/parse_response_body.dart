part of 'http.dart';

dynamic _parseResponseBody(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } on Exception catch (_) {
    return responseBody;
  }
}
