// signup_event.dart
part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class LoadSignUp extends SignupEvent {
  final SignUpParams signUpParams;
  LoadSignUp(this.signUpParams);
}