// login_event.dart
part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoadSendEmailCode extends LoginEvent {
  final String email;
  LoadSendEmailCode(this.email);
}

class LoadVerifyEmailCode extends LoginEvent {
  final String email;
  final String code;
  LoadVerifyEmailCode(this.email, this.code);
}

class LoadGoogleSignIn extends LoginEvent {}