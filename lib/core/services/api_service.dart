import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';
import '../models/post_model.dart';
import '../models/paper_model.dart';

class ApiService {
  // BaseUrl for the API - easily switch between localhost and production
  static const String baseUrl = 'https://api.spscready.com/api';

  /// Fetches the dynamic list of departments for the Home and Browse pages.
  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/departments'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => DepartmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print('Error fetching departments: $e');
      return [];
    }
  }

  /// Fetches the specific papers for a post by its ID.
  Future<List<PaperModel>> getPapersByPost(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/papers/post/$postId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaperModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load papers for post $postId');
      }
    } catch (e) {
      print('Error fetching papers by post: $e');
      return [];
    }
  }

  /// Handles the dynamic search logic for papers with optional filters.
  Future<List<PaperModel>> searchPapers(
    String query, {
    String? dept,
    String? year,
    String? stage,
  }) async {
    try {
      // Build query parameters
      final queryParameters = <String, String>{
        'q': query,
      };
      if (dept != null) queryParameters['dept'] = dept;
      if (year != null) queryParameters['year'] = year;
      if (stage != null) queryParameters['stage'] = stage;

      final uri = Uri.parse('$baseUrl/papers/search').replace(queryParameters: queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaperModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search papers');
      }
    } catch (e) {
      print('Error searching papers: $e');
      return [];
    }
  }

  /// Fetches posts for a specific department.
  Future<List<PostModel>> getPostsByDepartment(int departmentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/departments/$departmentId/posts'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts for department $departmentId');
      }
    } catch (e) {
      print('Error fetching posts by department: $e');
      return [];
    }
  }
}
