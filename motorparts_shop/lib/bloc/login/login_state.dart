import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String username;
  LoginSuccess(this.username);

  @override
  List<Object?> get props => [username];
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
