// lib/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../hive_service/hive_service.dart';

@immutable
abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  LoginRequested({required this.username, required this.password});
}

class LogoutRequested extends AuthEvent {}

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  AuthAuthenticated(this.username);
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final username = HiveService.currentUsername;
      if (username != null) {
        emit(AuthAuthenticated(username));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final ok = await HiveService.validateLogin(
          event.username,
          event.password,
        );
        if (ok) {
          emit(AuthAuthenticated(event.username));
        } else {
          emit(AuthFailure('Invalid username or password'));
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthFailure('Login error: $e'));
        emit(AuthUnauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await HiveService.logout();
      emit(AuthUnauthenticated());
    });
  }
}
