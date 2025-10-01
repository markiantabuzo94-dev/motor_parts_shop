import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String username;
  const AuthLoggedIn(this.username);

  @override
  List<Object?> get props => [username];
}

class AuthLoggedOut extends AuthEvent {}
