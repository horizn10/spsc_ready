import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Singleton pattern
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final _storage = const FlutterSecureStorage();
  
  // Use a final ValueNotifier to ensure the object reference never changes
  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  String? _accessToken;

  String? get token => _accessToken;

  Future<void> init() async {
    _accessToken = await _storage.read(key: 'accessToken');
    isLoggedIn.value = _accessToken != null;
    debugPrint('AuthService initialized: isLoggedIn = ${isLoggedIn.value}');
  }

  Future<void> login(String token) async {
    await _storage.write(key: 'accessToken', value: token);
    _accessToken = token;
    isLoggedIn.value = true;
    debugPrint('AuthService: User logged in');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    _accessToken = null;
    isLoggedIn.value = false;
    debugPrint('AuthService: User logged out');
  }

  Map<String, String> getAuthHeaders() {
    if (_accessToken != null) {
      return {'Authorization': 'Bearer $_accessToken'};
    }
    return {};
  }
}
