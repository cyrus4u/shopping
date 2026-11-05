// signup_bloc/bloc/signup_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopping/common/params/signup_params.dart';
import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/features/feature_auth/data/models/auth_user_model.dart';
import 'package:shopping/features/feature_auth/repositories/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';
part 'signup_data_status.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc(this.authRepository)
      : super(SignupState(signUpDataStatus: SignUpDataInitial())) {
    on<LoadSignUp>((event, emit) async {
      emit(state.copyWith(newSignUpDataStatus: SignUpDataLoading()));

      final DataState<AuthUserModel> dataState =
          await authRepository.signUp(event.signUpParams);

      if (dataState is DataSuccess<AuthUserModel>) {
        emit(state.copyWith(
            newSignUpDataStatus: SignUpCompleted(dataState.data!)));
      } else {
        emit(state.copyWith(
            newSignUpDataStatus:
                SignUpDataError(dataState.error ?? 'خطای ناشناخته')));
      }
    });
  }
}