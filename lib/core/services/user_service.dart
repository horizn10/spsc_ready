import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  // Use the same base URL logic as ApiService
  static const String baseUrl = 'https://192.168.40.200:7241/api';

  Future<UserModel?> getUserProfile() async {
    try {
      final token = AuthService().token;
      if (token == null) {
        debugPrint('UserService: No token found');
        return null;
      }

      // The endpoint is /api/account/profile (kshitiz branch)
      final url = '$baseUrl/account/profile';
      debugPrint('UserService: Fetching profile from $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint('UserService: Profile response code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        debugPrint('UserService: Unauthorized (Token expired?)');
        // Do not logout immediately to avoid loop, let the UI handle it
        return null;
      } else {
        debugPrint('UserService: Error ${response.statusCode} - ${response.body}');
        // If 404, it means the backend is missing the endpoint (common in branch desync)
        if (response.statusCode == 404) {
          debugPrint('UserService: ENDPOINT NOT FOUND. Ensure you merged the kshitiz branch into master on your backend.');
        }
        return null;
      }
    } catch (e) {
      debugPrint('Error in UserService.getUserProfile: $e');
      return null;
    }
  }
}
