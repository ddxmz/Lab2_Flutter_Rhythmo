import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleUserDatabase {
  static const String _usersKey = 'users';
  // username -> user info map
  Map<String, Map<String, String>> _users = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final decoded = jsonDecode(usersJson);
      _users = (decoded as Map<String, dynamic>).map((k, v) => MapEntry(k, Map<String, String>.from(v)));
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(_users));
  }

  Future<bool> addUser({
    required String username,
    required String password,
    required String firstname,
    required String surname,
    required String email,
  }) async {
    if (_users.containsKey(username)) return false;
    _users[username] = {
      'username': username,
      'password': password,
      'firstname': firstname,
      'surname': surname,
      'email': email,
    };
    await save();
    return true;
  }

  bool userExists(String username) => _users.containsKey(username);

  bool validateUser(String username, String password) {
    return _users[username]?['password'] == password;
  }

  Map<String, String>? getUser(String username) => _users[username];
}
