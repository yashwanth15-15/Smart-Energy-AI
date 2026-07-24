import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiClient {
  static final http.Client _client = http.Client();
  static const int _maxRetries = 3;

  static Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          headers['Authorization'] = 'Bearer $idToken';
        }
      } catch (_) {
        // Ignore error
      }
    }
    
    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final response = await _client.get(
          uri,
          headers: headers,
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode >= 500) {
          attempt++;
          if (attempt >= _maxRetries) {
            throw ApiException('Server error after $_maxRetries attempts', statusCode: response.statusCode);
          }
          await Future.delayed(Duration(seconds: attempt * 2));
        } else {
          throw ApiException('Client error: ${response.statusCode}', statusCode: response.statusCode);
        }
      } on TimeoutException {
        attempt++;
        if (attempt >= _maxRetries) {
          throw ApiException('Request timed out after $_maxRetries attempts');
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      } catch (e) {
        if (e is ApiException) rethrow;
        attempt++;
        if (attempt >= _maxRetries) {
          throw ApiException('Network error: $e');
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final response = await _client.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else if (response.statusCode >= 500) {
          attempt++;
          if (attempt >= _maxRetries) {
            throw ApiException('Server error after $_maxRetries attempts', statusCode: response.statusCode);
          }
          await Future.delayed(Duration(seconds: attempt * 2));
        } else {
          throw ApiException('Client error: ${response.statusCode}', statusCode: response.statusCode);
        }
      } on TimeoutException {
        attempt++;
        if (attempt >= _maxRetries) {
          throw ApiException('Request timed out after $_maxRetries attempts');
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      } catch (e) {
        if (e is ApiException) rethrow;
        attempt++;
        if (attempt >= _maxRetries) {
          throw ApiException('Network error: $e');
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
  }
}
