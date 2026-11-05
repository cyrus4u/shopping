// signup_data_status.dart
part of 'signup_bloc.dart';

@immutable
abstract class SignUpDataStatus {}

class SignUpDataInitial extends SignUpDataStatus {}

class SignUpDataLoading extends SignUpDataStatus {}

class SignUpCompleted extends SignUpDataStatus {
  final AuthUserModel user;
  SignUpCompleted(this.user);
}

class SignUpDataError extends SignUpDataStatus {
  final String errorMessage;
  SignUpDataError(this.errorMessage);
}