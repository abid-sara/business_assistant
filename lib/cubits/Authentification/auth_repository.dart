import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  SupabaseClient get client => _client;

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
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
      await _client.from('users').insert({'id': id, 'email': email, 'name': name});
    } catch (e) {
      throw Exception('Error adding user details: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> verifyResetCode(String email, String code) async {
    try {
      await _client.auth.verifyOTP(token: code, type: OtpType.recovery, email: email);
      return true;
    } catch (e) {
      throw Exception('Error verifying reset code: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}