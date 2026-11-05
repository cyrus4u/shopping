// features/feature_auth/repositories/auth_repository.dart
import 'package:shopping/common/params/login_params.dart';
import 'package:shopping/common/params/signup_params.dart';
import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/features/feature_auth/data/data_source/auth_api_provider.dart';
import 'package:shopping/features/feature_auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthApiProvider apiProvider;
  AuthRepository(this.apiProvider);

  Future<DataState<AuthUserModel>> signUp(SignUpParams params) async {
    try {
      final response = await apiProvider.callSignUp(params);
      final user = response.user;
      if (user == null) {
        return const DataFailed('ثبت نام انجام نشد. دوباره تلاش کنید');
      }
      return DataSuccess(AuthUserModel.fromUser(user, response.session));
    } on AuthException catch (e) {
      return DataFailed(_authMessage(e));
    } catch (_) {
      return const DataFailed(
        'خطا در اتصال به سرور. اینترنت خود را بررسی کنید',
      );
    }
  }

  Future<DataState<AuthUserModel>> login(LoginParams params) async {
    try {
      final response = await apiProvider.callLogin(params);
      final user = response.user;
      if (user == null) {
        return const DataFailed('ورود انجام نشد. دوباره تلاش کنید');
      }
      return DataSuccess(AuthUserModel.fromUser(user, response.session));
    } on AuthException catch (e) {
      return DataFailed(_authMessage(e));
    } catch (_) {
      return const DataFailed(
        'خطا در اتصال به سرور. اینترنت خود را بررسی کنید',
      );
    }
  }

  Future<void> logout() => apiProvider.callLogout();

  /// Maps Supabase error codes to user-facing Persian messages.
  String _authMessage(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return 'ایمیل یا رمز عبور اشتباه است';
      case 'user_already_exists':
      case 'email_exists':
        return 'این ایمیل قبلاً ثبت شده است';
      case 'weak_password':
        return 'رمز عبور ضعیف است (حداقل ۶ کاراکتر)';
      case 'email_not_confirmed':
        return 'ابتدا ایمیل خود را تایید کنید';
      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
        return 'تعداد درخواست‌ها زیاد است، کمی بعد دوباره تلاش کنید';
      case 'otp_expired':
        return 'کد اشتباه است یا منقضی شده';
      case 'email_address_invalid':
        return 'ایمیل معتبر نیست';
      default:
        return e.message;
    }
  }

  Future<DataState<bool>> sendEmailCode(String email) async {
    try {
      await apiProvider.callSendEmailCode(email);
      return const DataSuccess(true);
    } on AuthException catch (e) {
      return DataFailed(_authMessage(e));
    } catch (_) {
      return const DataFailed(
        'خطا در اتصال به سرور. اینترنت خود را بررسی کنید',
      );
    }
  }

  Future<DataState<AuthUserModel>> verifyEmailCode(
    String email,
    String code,
  ) async {
    try {
      final response = await apiProvider.callVerifyEmailCode(email, code);
      final user = response.user;
      final session = response.session;
      if (user == null || session == null) {
        return const DataFailed('کد معتبر نیست');
      }
      return DataSuccess(AuthUserModel.fromUser(user, session));
    } on AuthException catch (e) {
      return DataFailed(_authMessage(e));
    } catch (_) {
      return const DataFailed(
        'خطا در اتصال به سرور. اینترنت خود را بررسی کنید',
      );
    }
  }

  Future<DataState<bool>> signInWithGoogle() async {
    try {
      final launched = await apiProvider.callSignInWithGoogle();
      return launched
          ? const DataSuccess(true)
          : const DataFailed('ورود با گوگل شروع نشد');
    } on AuthException catch (e) {
      return DataFailed(_authMessage(e));
    } catch (_) {
      return const DataFailed('ورود با گوگل ناموفق بود');
    }
  }
}
