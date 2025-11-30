import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) async {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }

  // -------------------------- USER ID --------------------------
  void setUserId(String? userId) async {
    if (userId != null) {
      await _sharedPreferences.setString('user_id', userId);
    }
  }

  String? getUserId() {
    return _sharedPreferences.getString('user_id');
  }

  // -------------------------- CLEAR SESSION --------------------------
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
