abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String? userName = 'Guest'; 
  AuthAuthenticated();
}

class AuthUserNameFetched extends AuthState {
  final String userName;

  AuthUserNameFetched(this.userName);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}


class AuthLinkPressedState extends AuthState {
  final bool isLinkPressed;

  AuthLinkPressedState(this.isLinkPressed);
}

class AuthPasswordReset extends AuthState {}

class AuthCodeVerified extends AuthState {}

class SignUpSuccess extends AuthState {}
