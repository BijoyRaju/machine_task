import 'dart:convert';
import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_task/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Google Sign In Authentication Service
  Future<AuthUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        throw Exception('Failed to get access token');
      }

      final authUser = AuthUser(
        id: googleUser.id,
        email: googleUser.email,
        name: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl,
      );

      await _saveUser(authUser);
      return authUser;
    } catch (e) {
      log("Error in SignIn: $e");
      throw Exception('Google sign in failed: $e');
    }
  }

  // Signout the curent user
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _clearUser();
    } catch (e) {
      throw Exception('Google sign out failed: $e');
    }
  }

  // Get the current the user
  Future<AuthUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      if (userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        return AuthUser.fromJson(userJson);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Check the login status
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      throw Exception('Failed to check login status: $e');
    }
  }

  // Save the user data as a Private String
  Future<void> _saveUser(AuthUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }


  // Clear the user
  Future<void> _clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }
}
