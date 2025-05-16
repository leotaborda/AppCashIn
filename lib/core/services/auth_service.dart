import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyLoggedIn = 'is_logged_in';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<bool> login(String username, String password) async {
    // Credenciais fixas
    const validUsername = 'admin';
    const validPassword = '1234';

    if (username == validUsername && password == validPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyLoggedIn, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
  }
}
