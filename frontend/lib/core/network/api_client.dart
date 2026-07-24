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
    print('AUTH DEBUG: FirebaseAuth.instance.currentUser is ${user == null ? "null" : "NOT null"}');
    if (user != null) {
      print('AUTH DEBUG: currentUser.uid = ${user.uid}');
      try {
        print('AUTH DEBUG: Attempting user.getIdToken(false)');
        final idToken = await user.getIdToken();
        print('AUTH DEBUG: getIdToken(false) succeeded. Token length: ${idToken?.length}');
        if (idToken != null) {
          headers['Authorization'] = 'Bearer $idToken';
        }
      } catch (e) {
        print('AUTH DEBUG: getIdToken(false) threw exception!');
        print('AUTH DEBUG: Exception type: ${e.runtimeType}');
        print('AUTH DEBUG: Exception message: $e');
        
        try {
          print('AUTH DEBUG: Attempting user.getIdToken(true) [forceRefresh]');
          final forceToken = await user.getIdToken(true);
          print('AUTH DEBUG: forceRefresh=true succeeded. Token length: ${forceToken?.length}');
        } catch (forceErr) {
          print('AUTH DEBUG: forceRefresh=true also threw exception: $forceErr');
        }
        
        throw ApiException('Failed to retrieve authentication token: $e', statusCode: 401);
      }
    } else {
      print('AUTH DEBUG: user is null, proceeding without Authorization header');
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
