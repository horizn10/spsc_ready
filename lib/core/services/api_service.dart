import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';
import '../models/post_model.dart';
import '../models/paper_model.dart';
import 'auth_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator. 
  // HTTPS: 7241, HTTP: 5116 (Based on standard .NET configurations)
  static const String baseUrl = 'https://10.0.2.2:7241/api';

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    // We include headers, but if the backend has [AllowAnonymous], it will ignore missing tokens.
    headers.addAll(AuthService().getAuthHeaders());
    return headers;
  }

  /// Fetches the dynamic list of departments from the PapersController
  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Papers/departments'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => DepartmentModel.fromJson(json)).toList();
      } else {
        print('ApiService Error (${response.statusCode}): ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching departments: $e');
      return [];
    }
  }

  /// Fetches all papers or filtered papers from the main Papers endpoint
  Future<List<PaperModel>> getAllPapers() async {
    return searchPapers(''); // Reuses searchPapers logic without query
  }

  /// Fetches the specific papers for a post by its Name (aligned with backend query params).
  Future<List<PaperModel>> getPapersByPost(String postName) async {
    return searchPapers('', postName: postName);
  }

  /// Handles the search and filtering logic using the query parameters defined in your PapersController
  Future<List<PaperModel>> searchPapers(
    String query, {
    String? dept,
    String? year,
    String? stage,
    String? postName,
  }) async {
    try {
      final queryParameters = <String, String>{};
      
      if (query.isNotEmpty) queryParameters['search'] = query;
      if (dept != null) queryParameters['departmentName'] = dept;
      if (year != null) queryParameters['examYear'] = year;
      if (stage != null) queryParameters['stageName'] = stage;
      if (postName != null) queryParameters['postName'] = postName;

      final uri = Uri.parse('$baseUrl/Papers').replace(queryParameters: queryParameters);
      print('Requesting Papers: $uri');
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaperModel.fromJson(json)).toList();
      } else {
        print('ApiService Error (${response.statusCode}): ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching papers: $e');
      return [];
    }
  }

  /// Fetches posts for a specific department using the ID
  Future<List<PostModel>> getPostsByDepartment(String departmentId) async {
    try {
      final uri = Uri.parse('$baseUrl/Papers/posts').replace(
        queryParameters: {'departmentId': departmentId}
      );
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        print('ApiService Error (${response.statusCode}): ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
