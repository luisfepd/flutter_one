import '../../../domain/models/user/user.dart';
import '../../http/http.dart';

class AccountAPI {
  AccountAPI({required Http http}) : _http = http;

  final Http _http;

  Future<User?> getAccount(String sessionId) async {
    final result = await _http.request(
      '/account',
      queryParameters: {
        'session_id': sessionId,
      },
      onSuccess: (json) {
        return User.fromJson(json);
      },
    );
    return result.when(
      left: (_) => null,
      right: (user) => user,
    );
  }
}
