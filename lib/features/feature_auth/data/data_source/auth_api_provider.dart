// features/feature_auth/data/data_source/auth_api_provider.dart
import 'package:shopping/common/params/login_params.dart';
import 'package:shopping/common/params/signup_params.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopping/config/auth_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shopping/config/auth_config.dart';

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

  static Future<void>? _googleInit;

  Future<void> _ensureGoogleInit() => _googleInit ??= GoogleSignIn.instance
      .initialize(serverClientId: AuthConfig.googleWebClientId);

  Future<bool> callSignInWithGoogle() async {
    // Web: browser redirect, as before.
    if (kIsWeb) {
      return _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: AuthConfig.googleRedirect,
      );
    }

    // Android / iOS: native account sheet.
    try {
      await _ensureGoogleInit();
      final account = await GoogleSignIn.instance.authenticate();

      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('No ID token received from Google');
      }

      // Supabase's docs list the access token as required for Google sign-in.
      final scopes = ['email', 'profile'];
      final authz =
          await account.authorizationClient.authorizationForScopes(scopes) ??
          await account.authorizationClient.authorizeScopes(scopes);

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authz.accessToken,
      );
      AppLogger.info('native google sign-in done', name: _tag);
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return true; // the user closed the sheet, so it's not an error
      }
      AppLogger.error('google sign-in failed: ${e.code}', error: e, name: _tag);
      rethrow;
    }
  }
}
