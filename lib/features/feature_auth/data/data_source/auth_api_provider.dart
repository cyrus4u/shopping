// features/feature_auth/data/data_source/auth_api_provider.dart
import 'package:shopping/common/params/login_params.dart';
import 'package:shopping/common/params/signup_params.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthApiProvider {
  static const _tag = 'AuthApi';

  final SupabaseClient _client;
  AuthApiProvider(this._client);

  Future<AuthResponse> callSignUp(SignUpParams params) async {
    try {
      final response = await _client.auth.signUp(
        email: params.email,
        password: params.password,
        data: {'name': params.name}, // stored in user metadata
      );
      AppLogger.info('signUp done', name: _tag);
      return response;
    } on AuthException catch (e, st) {
      AppLogger.error(
        'signUp failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Unexpected error in signUp',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }

  Future<AuthResponse> callLogin(LoginParams params) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: params.email,
        password: params.password,
      );
      AppLogger.info('login done', name: _tag);
      return response;
    } on AuthException catch (e, st) {
      AppLogger.error(
        'login failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Unexpected error in login',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }

  Future<void> callLogout() => _client.auth.signOut();

  Future<void> callSendEmailCode(String email) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true, // new email => account is created automatically
      );
      AppLogger.info('email code sent', name: _tag);
    } on AuthException catch (e, st) {
      AppLogger.error(
        'send code failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }

  Future<AuthResponse> callVerifyEmailCode(String email, String code) async {
    try {
      return await _client.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.email,
      );
    } on AuthException catch (e, st) {
      AppLogger.error(
        'verify code failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }

  Future<bool> callSignInWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? Uri.base.origin : null,
    );
  }
}
