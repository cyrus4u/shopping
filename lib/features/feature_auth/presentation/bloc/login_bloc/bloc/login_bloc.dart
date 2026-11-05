// login_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/features/feature_auth/data/models/auth_user_model.dart';
import 'package:shopping/features/feature_auth/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_data_status.dart';
part 'code_check_status.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository)
      : super(LoginState(
          loginDataStatus: LoginDataInitial(),
          codeCheckStatus: CodeCheckInitial(),
        )) {
    /// Step 1: email -> code
    on<LoadSendEmailCode>((event, emit) async {
      emit(state.copyWith(newLoginDataStatus: LoginDataLoading()));
      final result = await authRepository.sendEmailCode(event.email);
      emit(state.copyWith(
        newLoginDataStatus: result is DataSuccess
            ? LoginDataCompleted()
            : LoginDataError(result.error ?? 'خطای ناشناخته'),
      ));
    });

    /// Step 2: code -> session
    on<LoadVerifyEmailCode>((event, emit) async {
      emit(state.copyWith(newCodeCheckStatus: CodeCheckLoading()));
      final DataState<AuthUserModel> result =
          await authRepository.verifyEmailCode(event.email, event.code);
      emit(state.copyWith(
        newCodeCheckStatus: result is DataSuccess<AuthUserModel>
            ? CodeCheckCompleted(result.data!)
            : CodeCheckError(result.error ?? 'خطای ناشناخته'),
      ));
    });

    /// Google: on success the browser leaves the app, so we only report failures.
    on<LoadGoogleSignIn>((event, emit) async {
      final result = await authRepository.signInWithGoogle();
      if (result is DataFailed) {
        emit(state.copyWith(
          newLoginDataStatus: LoginDataError(result.error ?? 'خطای ناشناخته'),
        ));
      }
    });
  }
}