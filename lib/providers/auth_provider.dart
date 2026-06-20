import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/dummy_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final storedPassword = DummyData.credentials[email];
    if (storedPassword != null && storedPassword == password) {
      _currentUser = DummyData.users.firstWhere((u) => u.email == email);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Email atau password salah';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
