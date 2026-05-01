import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == UserRole.admin;
  bool get isClient => _user?.role == UserRole.client;

  // Demo accounts
  static final _accounts = <String, UserModel>{
    'amina@vcreations.cd': UserModel(
      id: 'u1',
      name: 'Amina Kabila',
      email: 'amina@vcreations.cd',
      phone: '+243810000001',
      role: UserRole.client,
      memberSince: '2023',
      isPrivate: true,
    ),
    'admin@vcreations.cd': UserModel(
      id: 'admin1',
      name: 'Admin VCréations',
      email: 'admin@vcreations.cd',
      phone: '+243810000000',
      role: UserRole.admin,
      memberSince: '2022',
    ),
  };

  static const _passwords = <String, String>{
    'amina@vcreations.cd': 'client123',
    'admin@vcreations.cd': 'admin123',
  };

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final account = _accounts[email.trim().toLowerCase()];
    final pwd = _passwords[email.trim().toLowerCase()];

    if (account != null && pwd == password) {
      _user = account;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Email ou mot de passe incorrect.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_accounts.containsKey(email.toLowerCase())) {
      _error = 'Un compte existe déjà avec cet email.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = UserModel(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.client,
      memberSince: DateTime.now().year.toString(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
