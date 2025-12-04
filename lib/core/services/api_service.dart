import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://login.wild-fantasy.com';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> authenticatedRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    String? token = await _storage.read(key: 'token');

    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response;

    try {
      if (method == 'POST') {
        response = await http.post(url, headers: headers, body: jsonEncode(body));
      } else if (method == 'PUT') {
        response = await http.put(url, headers: headers, body: jsonEncode(body));
      } else if (method == 'DELETE') {
        response = await http.delete(url, headers: headers);
      } else {
        response = await http.get(url, headers: headers);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        final bool refreshed = await _refreshToken();

        if (refreshed) {
          final newToken = await _storage.read(key: 'token');
          headers['Authorization'] = 'Bearer $newToken';

          if (method == 'POST') {
            response = await http.post(url, headers: headers, body: jsonEncode(body));
          } else if (method == 'PUT') {
            response = await http.put(url, headers: headers, body: jsonEncode(body));
          } else if (method == 'DELETE') {
            response = await http.delete(url, headers: headers);
          } else {
            response = await http.get(url, headers: headers);
          }
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.StreamedResponse> multipartRequest(
    String endpoint, {
    String method = 'POST',
    Map<String, String>? fields,
    File? file,
    String? fileField,
  }) async {
    String? token = await _storage.read(key: 'token');
    final url = Uri.parse('$_baseUrl$endpoint');

    var request = http.MultipartRequest(method, url);
    request.headers['Authorization'] = 'Bearer $token';

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (file != null && fileField != null) {
      request.files.add(await http.MultipartFile.fromPath(fileField, file.path));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 401 || response.statusCode == 403) {
        final bool refreshed = await _refreshToken();
        if (refreshed) {
          final newToken = await _storage.read(key: 'token');
          
          // Create a new request since the old one has been sent
          request = http.MultipartRequest(method, url);
          request.headers['Authorization'] = 'Bearer $newToken';
          
          if (fields != null) {
            request.fields.addAll(fields);
          }
          if (file != null && fileField != null) {
            request.files.add(await http.MultipartFile.fromPath(fileField, file.path));
          }
          
          response = await request.send();
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refreshToken');

      if (refreshToken == null) return false;

      final url = Uri.parse('$_baseUrl/auth/refresh');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        
        await _storage.write(key: 'token', value: newAccessToken);
        return true;
      } else {
        await _storage.deleteAll();
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<Map<String, int>> getUserCounts() async {
    try {
      final response = await authenticatedRequest('/stats/user-counts');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'characterCount': data['characterCount'] as int,
          'itemCount': data['itemCount'] as int,
        };
      }
      return {'characterCount': 0, 'itemCount': 0};
    } catch (e) {
      return {'characterCount': 0, 'itemCount': 0};
    }
  }

  Future<List<dynamic>> search(String query) async {
    try {
      final response = await authenticatedRequest('/search?q=$query');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}