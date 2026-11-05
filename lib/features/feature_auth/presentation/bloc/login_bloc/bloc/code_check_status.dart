// code_check_status.dart
part of 'login_bloc.dart';

@immutable
abstract class CodeCheckStatus {}

class CodeCheckInitial extends CodeCheckStatus {}

class CodeCheckLoading extends CodeCheckStatus {}

class CodeCheckCompleted extends CodeCheckStatus {
  final AuthUserModel user;
  CodeCheckCompleted(this.user);
}

class CodeCheckError extends CodeCheckStatus {
  final String errorMessage;
  CodeCheckError(this.errorMessage);
}