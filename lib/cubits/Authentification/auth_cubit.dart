import 'package:bloc/bloc.dart';
import 'package:business_assistant/cubits/Authentification/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  supabase.SupabaseClient get _client => _authRepository.client; 

  Future<Map<String, dynamic>?> fetchUserFromDatabase() async {
    try {
      final email = _client.auth.currentUser?.email;
      if (email == null) {
        throw Exception('No authenticated user found');
      }

      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      // Safely access response.data with null-aware operator
      if (response == null) {
        return null; // No user found
      }

      return response; // Return data if it exists
    } catch (e) {
      throw Exception('Error fetching user from database: $e');
    }
  }
  
  Future<bool> isUserAlreadyExists(String email) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Error checking if user exists: $e');
    }
  }

  void checkAuthentication(BuildContext context) {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated());
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/dashboard'));
    } else {
      emit(AuthInitial());
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/CreateAccount'));
    }
  }

  supabase.User? getCurrentUser() {
    return _client.auth.currentUser;
  }



  Future<void> signUp(String email, String password, String name, BuildContext context) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signUp(email, password);
      if (response.user != null) {
        await _authRepository.addUserDetails(
          id: response.user!.id,
          email: email,
          name: name,
        );
        emit(SignUpSuccess());
        Navigator.pushReplacementNamed(context, '/SignIn');
      } else {
        emit(AuthError('Sign-up failed'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
    }
  }
  Future<String?> fetchUserName() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final response = await _client
          .from('users')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        return null; // No user name found
      }
      return response['name'] as String?;
    } catch (e) {
      throw Exception('Error fetching user name: $e');
    }
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signIn(email, password);
      if (response.user != null) {
        emit(AuthAuthenticated());
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        emit(AuthError('Authentication failed'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(email);
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthError('Failed to send reset email: $e'));
    }
  }

  Future<bool> verifyResetCode(String email, String code) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.verifyResetCode(email, code);
      if (success) {
        emit(AuthCodeVerified());
        return true;
      } else {
        emit(AuthError('Invalid verification code.'));
        return false;
      }
    } catch (e) {
      emit(AuthError('Error verifying code: $e'));
      return false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await _authRepository.updatePassword(newPassword);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError('Failed to update password: $e'));
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
      Navigator.pushReplacementNamed(context, '/welcome');
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
    }
  }
}