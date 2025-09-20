import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasReachedMax = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasReachedMax => _hasReachedMax;

  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _users.clear();
      _hasReachedMax = false;
    }

    if (_hasReachedMax && !refresh) return;

    _setLoading(true);
    try {
      final response = await _apiService.getUsers(_currentPage);
      if (refresh) {
        _users = response.users;
      } else {
        _users.addAll(response.users);
      }
      _hasReachedMax = !response.hasMore;
      _currentPage++;
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMoreUsers() async {
    if (!_hasReachedMax && !_isLoading) {
      await loadUsers();
    }
  }

  Future<User> getUser(int id) async {
    try {
      return await _apiService.getUser(id);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<void> createUser(User user) async {
    _setLoading(true);
    try {
      final createdUser = await _apiService.createUser(user);
      _users.insert(0, createdUser);
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(int id, User user) async {
    _setLoading(true);
    try {
      final updatedUser = await _apiService.updateUser(id, user);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteUser(int id) async {
    _setLoading(true);
    try {
      await _apiService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
