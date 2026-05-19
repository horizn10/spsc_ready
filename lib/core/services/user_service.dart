import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  // Use the same base URL logic as ApiService
  static const String baseUrl = 'https://10.0.2.2:7241/api';

  Future<UserModel?> getUserProfile() async {
    try {
      final token = AuthService().token;
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/User/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        // Token might be expired
        await AuthService().logout();
        return null;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in UserService.getUserProfile: $e');
      rethrow;
    }
  }
}
