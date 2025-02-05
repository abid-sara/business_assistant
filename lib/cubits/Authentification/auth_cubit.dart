import 'package:bloc/bloc.dart';
import 'package:business_assistant/cubits/Authentification/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  supabase.SupabaseClient get _client => _authRepository.client;

  Future<String?> fetchUserName() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final response = await _client
          .from('user')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        return null; 
      }
      return response['name'] as String?;
    } catch (e) {
      throw Exception('Error fetching user name: $e');
    }
  }


 void checkAuthentication(BuildContext context) async {
  try {
    final session = _client.auth.currentSession;
    final user = session?.user; 
    print("Current user from session: $user");

    if (user != null) {
      final userDetails = await _client
          .from('user')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (userDetails != null) {
     
        emit(AuthAuthenticated());
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } 
    } else {
      
      emit(AuthInitial());
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/signIn');
      }
    }
  } catch (e) {
    print('Error during authentication check: $e');
    emit(AuthError('An error occurred during authentication check'));
  }
}


  supabase.User? getCurrentUser() {
  return _client.auth.currentUser;  
}

  Future<void> signUp(String email, String password, String name, BuildContext context) async {
  print("Starting sign-up process...");  
    emit(AuthLoading());
    try {
    print("Attempting to sign up with email: $email");  
      final response = await _authRepository.signUp(email, password);
    print("Sign-up response: ${response.user}");  

      if (response.user != null) {
      print("User signed up successfully. User ID: ${response.user!.id}");  

      print("Adding user details: ID = ${response.user!.id}, Email = $email, Name = $name");
      await _authRepository.addUserDetails(
        id: response.user!.id,
        email: email,
        name: name,
      );
      
      print("User details added successfully.");  
        emit(SignUpSuccess());
      if (context.mounted) {
        print("Navigating to dashboard...");  
  
        Future.microtask(() => Navigator.pushReplacementNamed(context, '/dashboard'));
      } else {
        print("Context is no longer mounted, unable to navigate.");  
      }
    } else {
      print("Sign-up failed: Response did not contain user data.");  
        emit(AuthError('Sign-up failed'));
      }
    } catch (e) {
    print("Error during sign-up: $e");  
      emit(AuthError('An error occurred: $e'));
    }
  }

  Future<void> signInWithPassword(String email, String password, BuildContext context) async {
  emit(AuthLoading());
  try {
    final authResponse = await _authRepository.signIn(email, password);

    if (authResponse.user != null) {
      print("User signed in successfully: ${authResponse.user!.email}");

      emit(AuthAuthenticated());
      Navigator.pushReplacementNamed(context, '/dashboard'); 
    } else {
      emit(AuthError('Incorrect email or password.'));
      print("Sign-in failed: Invalid credentials.");
    }
  } catch (e) {
    print("Error during sign-in: $e");

    
    if (e is AuthException) {
      emit(AuthError('Authentication failed: ${e.message}'));
    } else {
      emit(AuthError('An unexpected error occurred: $e'));
    }
  }
}


void setLinkPressed(bool isPressed) {
    emit(AuthLinkPressedState(isPressed));
  }

Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
  emit(AuthLoading());
  try {
    final response = await _authRepository.sendResetPasswordLink(email);

    if (response != null) {
      print("Password reset email sent successfully!");
      emit(AuthLinkPressedState(true)); 
      Navigator.pushReplacementNamed(context, '/ResetPassword');
    } else {
      emit(AuthError('Failed to send password reset email.'));
    }
  } catch (e) {
    print("Error during password reset: $e");
    emit(AuthError('An error occurred: $e'));
  }
}




Future<void> updatePassword(String newPassword, BuildContext context) async {
  emit(AuthLoading());
  try {
    final response = await _client.auth.updateUser(supabase.UserAttributes(
      password: newPassword,
    ));

    

    print('Password updated successfully!');
    emit(AuthAuthenticated()); 
    Navigator.pushReplacementNamed(context, '/dashboard'); 
  } catch (e) {
    emit(AuthError('Error updating password: $e'));
  }
}



  Future<void> signOut(BuildContext context) async {
  emit(AuthLoading());
  try {
    await _authRepository.signOut();
    await _client.auth.signOut();
    emit(AuthInitial());
    Future.microtask(() => Navigator.pushReplacementNamed(context, '/welcome'));
  } catch (e) {
    emit(AuthError('An error occurred: $e'));
  }
}

}

