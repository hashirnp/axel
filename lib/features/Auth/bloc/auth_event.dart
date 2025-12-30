part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;
  LoginRequested(this.username, this.password, this.rememberMe);
}

class RegisterRequested extends AuthEvent {
  final User user;
  RegisterRequested(this.user);
}
