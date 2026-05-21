import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';
import '../models/post_model.dart';
import '../models/paper_model.dart';
import 'auth_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator. 
  // HTTPS: 7241, HTTP: 5116 (Based on standard .NET configurations)
  // Use 192.168.40.200 for Physical Phone
  static const String baseUrl = 'https://192.168.40.200:7241/api';

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
      ).timeout(const Duration(seconds: 60));

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
    return searchPapers('', postNames: [postName]);
  }

  /// Handles the search and filtering logic using the query parameters defined in your PapersController
  Future<List<PaperModel>> searchPapers(
    String query, {
    List<String>? depts,
    List<String>? years,
    List<String>? stages,
    List<String>? postNames,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      
      if (query.isNotEmpty) queryParameters['search'] = query;
      if (depts != null && depts.isNotEmpty) queryParameters['departmentName'] = depts;
      if (years != null && years.isNotEmpty) queryParameters['examYear'] = years;
      if (stages != null && stages.isNotEmpty) queryParameters['stageName'] = stages;
      if (postNames != null && postNames.isNotEmpty) queryParameters['postName'] = postNames;

      // Ensure the endpoint is correct: /api/papers
      final uri = Uri.parse('$baseUrl/papers').replace(queryParameters: queryParameters);
      print('Requesting Papers: $uri');
      
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => PaperModel.fromJson(json))
            .where((paper) => paper.paperName.isNotEmpty)
            .toList();
      } else {
        print('ApiService Error (${response.statusCode}): ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching papers: $e');
      return [];
    }
  }

  /// Fetches the R2 PDF URL for a specific paper on demand.
  /// Only called when the user taps "View Paper".
  Future<String> getPdfUrl(String paperId) async {
    try {
      final uri = Uri.parse('$baseUrl/papers/$paperId/pdf-url');
      print('Fetching PDF URL for paper $paperId: $uri');
      final response = await http.get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final url = (data['url'] ?? data['Url'] ?? '').toString().trim();
        print('Got PDF URL: $url');
        return url;
      } else {
        print('getPdfUrl Error (${response.statusCode}): ${response.body}');
        return '';
      }
    } catch (e) {
      print('Error fetching PDF URL: $e');
      return '';
    }
  }

  /// Fetches posts for a specific department using the ID
  Future<List<PostModel>> getPostsByDepartment(String departmentId) async {
    try {
      final uri = Uri.parse('$baseUrl/Papers/posts').replace(
        queryParameters: {'departmentId': departmentId}
      );
      
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 60));

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
