import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  SupabaseClient get client => _client;
  


  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await _client.auth.signUp(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addUserDetails({required String id, required String email, required String name}) async {
    try {
      await _client.from('user').insert({'id': id, 'email': email, 'name': name});
    } catch (e) {
      throw Exception('Error adding user details: $e');
    }
  }



Future<void> updatePassword(String newPassword) async {
  try {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final response = await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    print('Password updated successfully for ${user.email}');
  } catch (e) {
    print('Error updating password: $e');
    throw Exception('Failed to update password');
  }
}

Future<String?> sendResetPasswordLink(String email) async {
  try {
    final response = await _client.auth.resetPasswordForEmail(email);
    
    return 'Password reset link sent';  // Return a success message or null
  } catch (e) {
    print("Error in sending reset password email: $e");
    return null;  // Return null in case of an error
  }
}



  Future<User?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<void> signOut() async {

    await client.auth.signOut();

  }

}

