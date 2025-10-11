import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  String toString() => 'AuthInitial';
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  String toString() => 'AuthLoading';
}

class AuthAuthenticated extends AuthState {
  final String username;
  const AuthAuthenticated(this.username);
  @override
  List<Object?> get props => [username];
  @override
  String toString() => 'AuthAuthenticated(username: $username)';
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
  @override
  String toString() => 'AuthUnauthenticated';
}
