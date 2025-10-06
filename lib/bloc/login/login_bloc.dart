import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive_service/hive_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      final isValid = await HiveService.validateLogin(
        event.username,
        event.password,
      );

      if (isValid) {
        emit(LoginSuccess(event.username));
      } else {
        emit(LoginFailure("Invalid username or password"));
      }
    });
  }
}
