import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  bool _isDarkMode = false;
  int _visitCount = 0;

  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    int count = prefs.getInt('visit_count') ?? 0;
    count += 1;
    await prefs.setInt('visit_count', count);
    _visitCount = count;

    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;

    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final favorites = prefs.getStringList('favorites') ?? [];

    _user = User(
      name: name,
      email: email,
      isLoggedIn: isLoggedIn,
      favorites: favorites,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', value);
  }

  Future<bool> updateUser(User newUser) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);
    await prefs.setStringList('favorites', newUser.favorites);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> addFavorite(String item) async {
    if (item.trim().isEmpty || _user.favorites.contains(item)) return;
    final updatedList = List<String>.from(_user.favorites)..add(item.trim());
    final updatedUser = _user.copyWith(favorites: updatedList);
    await updateUser(updatedUser);
  }

  Future<void> removeFavorite(String item) async {
    final updatedList = List<String>.from(_user.favorites)..remove(item);
    final updatedUser = _user.copyWith(favorites: updatedList);
    await updateUser(updatedUser);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);

    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }
}
