import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _fullName = '';
  String _password = '';
  String? _email; // ✅ Tambahkan email
  String? _token;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  String get username => _username;
  String get fullName => _fullName;
  String? get email => _email; // ✅ Getter email
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  // Register new user
  Future<void> register({
    required String username,
    required String password,
    required String fullName,
    required String email, // ✅ Tambahkan parameter email
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Cek apakah username sudah digunakan
      if (prefs.containsKey('username')) {
        throw Exception('Username already exists');
      }

      // Simpan data ke SharedPreferences
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setString('fullName', fullName);
      await prefs.setString('email', email); // ✅ Simpan email

      // Buat token
      _token = 'token_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('token', _token!);
      await prefs.setBool('isLoggedIn', true);

      // Update state
      _username = username;
      _fullName = fullName;
      _password = password;
      _email = email;
      _isLoggedIn = true;
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');
      final storedPassword = prefs.getString('password');
      final storedFullName = prefs.getString('fullName');
      final storedEmail = prefs.getString('email'); // ✅ Ambil email

      if (storedUsername == null || storedPassword == null) {
        throw Exception('User not registered');
      }

      if (username != storedUsername || password != storedPassword) {
        throw Exception('Invalid username or password');
      }

      _username = storedUsername;
      _fullName = storedFullName ?? '';
      _password = storedPassword;
      _email = storedEmail;
      _isLoggedIn = true;
      _token =
          prefs.getString('token') ??
          'token_${DateTime.now().millisecondsSinceEpoch}';

      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user on app start
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? '';
      _fullName = prefs.getString('fullName') ?? '';
      _password = prefs.getString('password') ?? '';
      _email = prefs.getString('email'); // ✅ Ambil email
      _token = prefs.getString('token');
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      debugPrint('Error loading user: $e');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.setBool('isLoggedIn', false);

      _token = null;
      _isLoggedIn = false;
    } catch (e) {
      debugPrint('Logout error: $e');
      _token = null;
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_password != oldPassword) {
        throw Exception('Current password is incorrect');
      }

      if (newPassword.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      await prefs.setString('password', newPassword);
      _password = newPassword;
      notifyListeners();
    } catch (e) {
      debugPrint('Password change error: $e');
      rethrow;
    }
  }

  // Update full name
  Future<void> setFullName(String newName) async {
    try {
      if (newName.isEmpty) {
        throw Exception('Name cannot be empty');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', newName);
      _fullName = newName;
      notifyListeners();
    } catch (e) {
      debugPrint('Name update error: $e');
      rethrow;
    }
  }

  // Cek username
  Future<bool> userExists(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') == username;
  }

  // Clear all user data
  Future<void> clearAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _username = '';
      _fullName = '';
      _password = '';
      _email = null;
      _token = null;
      _isLoggedIn = false;
    } catch (e) {
      debugPrint('Clear data error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
