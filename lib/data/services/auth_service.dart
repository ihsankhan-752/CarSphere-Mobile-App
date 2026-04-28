import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String userBaseUrl = 'http://10.0.2.2:8000/user';
  static const String sellerBaseUrl = 'http://10.0.2.2:8000/seller';

  Future<UserModel> signUp(Map<String, dynamic> data, String role) async {
    final url = role == 'seller'
        ? '$sellerBaseUrl/signup'
        : '$userBaseUrl/signup';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return UserModel.fromJson(decoded);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to sign up');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Connection timed out. Please try again.');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    String role,
  ) async {
    final url = role == 'seller'
        ? '$sellerBaseUrl/login'
        : '$userBaseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (role == 'seller') {
          return {
            'token': decoded['token'],
            'user': decoded['seller'],
          };
        }
        return decoded;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to login');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Connection timed out. Please try again.');
      }
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser(String token, String role) async {
    final baseUrl = role == 'seller' ? sellerBaseUrl : userBaseUrl;
    print('DEBUG: Fetching current $role info from $baseUrl/me...');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 7));
      print('DEBUG: getCurrentUser response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return UserModel.fromJson(decoded);
      } else {
        throw Exception('Failed to fetch user information');
      }
    } catch (e) {
      print('DEBUG: Error in getCurrentUser: $e');
      throw Exception('Failed to fetch user information');
    }
  }
}
