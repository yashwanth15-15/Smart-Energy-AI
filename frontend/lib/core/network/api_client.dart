import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final response = await _client.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode >= 500) {
          // Retry on server errors
          attempt++;
          if (attempt >= _maxRetries) {
            throw ApiException('Server error after $_maxRetries attempts', statusCode: response.statusCode);
          }
          await Future.delayed(Duration(seconds: attempt * 2)); // Exponential backoff
        } else {
          // Client errors (4xx) - don't retry
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
