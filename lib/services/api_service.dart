import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://reqres.in';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1',
      },
    ));
  }

  Future<UserListResponse> getUsers(int page) async {
    try {
      final response = await _dio.get('/api/users', queryParameters: {'page': page});
      return UserListResponse.fromJson(response.data);
    } catch (e) {
      log("Error in fetching users: $e");
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<User> getUser(int id) async {
    try {
      final response = await _dio.get('/api/users/$id');
      return User.fromJson(response.data['data']);
    } catch (e) {
      log("Error in fetching users: $e");
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      await _dio.post('/api/users', data: {
        'name': user.fullName,
        'job': 'Developer',
      });
      
      // Since reqres.in doesn't return the created user with all fields,
      // we'll create a mock response with the provided data
      return User(
        id: DateTime.now().millisecondsSinceEpoch,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(int id, User user) async {
    try {
      await _dio.put('/api/users/$id', data: {
        'name': user.fullName,
        'job': 'Developer',
      });
      
      return User(
        id: id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/api/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
