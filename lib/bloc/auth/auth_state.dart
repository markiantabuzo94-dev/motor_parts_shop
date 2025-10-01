import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  AuthAuthenticated(this.username);

  @override
  List<Object?> get props => [username];
}

class AuthUnauthenticated extends AuthState {}
