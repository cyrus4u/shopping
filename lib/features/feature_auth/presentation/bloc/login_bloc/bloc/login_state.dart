// login_state.dart
part of 'login_bloc.dart';

class LoginState {
  final LoginDataStatus loginDataStatus; // "send code" step
  final CodeCheckStatus codeCheckStatus; // "verify code" step

  LoginState({required this.loginDataStatus, required this.codeCheckStatus});

  LoginState copyWith({
    LoginDataStatus? newLoginDataStatus,
    CodeCheckStatus? newCodeCheckStatus,
  }) {
    return LoginState(
      loginDataStatus: newLoginDataStatus ?? loginDataStatus,
      codeCheckStatus: newCodeCheckStatus ?? codeCheckStatus,
    );
  }
}