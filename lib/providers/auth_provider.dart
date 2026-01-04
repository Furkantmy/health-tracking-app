import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  // Giriş yapma
  void login(String name, String email) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  // Çıkış yapma
  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }

  // Kullanıcı bilgilerini güncelle
  void updateUserInfo(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }
}
