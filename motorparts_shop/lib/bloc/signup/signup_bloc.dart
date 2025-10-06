import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive_service/hive_service.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String message;
  SignUpFailure(this.message);
}

abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  SignUpButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpLoading());

      try {
        final isRegistered = await HiveService.saveUser(
          firstName: event.firstName,
          lastName: event.lastName,
          username: event.username,
          email: event.email,
          password: event.password,
        );

        if (isRegistered) {
          emit(SignUpSuccess());
        } else {
          emit(SignUpFailure("Username already exists"));
        }
      } catch (e) {
        emit(SignUpFailure("Registration failed: ${e.toString()}"));
      }
    });
  }
}
