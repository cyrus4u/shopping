// signup_state.dart
part of 'signup_bloc.dart';

class SignupState {
  final SignUpDataStatus signUpDataStatus;

  SignupState({required this.signUpDataStatus});

  SignupState copyWith({SignUpDataStatus? newSignUpDataStatus}) {
    return SignupState(
      signUpDataStatus: newSignUpDataStatus ?? signUpDataStatus,
    );
  }
}