import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    // We don't notify here to avoid "setState during build" errors
    // when called from SplashScreen's initState.
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final role = prefs.getString('user_role') ?? 'buyer';

      if (token != null) {
        final user = await _authService.getCurrentUser(token, role);
        if (user != null) {
          _user = UserModel(
            userId: user.userId,
            username: user.username,
            email: user.email,
            role: user.role,
            phone: user.phone,
            city: user.city,
            token: token,
          );
        }
      }
    } catch (e) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUp({
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'city': city,
      }, role);

      _isLoading = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password, role);
      final token = response['token']?.toString() ?? '';
      final userData = response['user'] as Map<String, dynamic>?;

      // Handle both nested { token, user: {...} } and flat { token, ...userFields } responses
      final finalUserData = userData ?? response;

      _user = UserModel.fromJson({
        ...finalUserData, 
        'token': token,
        'role': finalUserData['role'] ?? role,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_role', _user!.role);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    _user = null;
    notifyListeners();
  }
}
