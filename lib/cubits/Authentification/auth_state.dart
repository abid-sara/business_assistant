abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthPasswordReset extends AuthState {}

class AuthCodeVerified extends AuthState {}

class SignUpSuccess extends AuthState {}