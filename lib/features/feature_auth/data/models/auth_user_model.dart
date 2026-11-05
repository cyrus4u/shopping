// features/feature_auth/data/models/auth_user_model.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// One small model replaces SignupModel, CodeModel and LoginWithSmsModel.
class AuthUserModel {
  final String id;
  final String email;
  final String name;

  /// null => no session yet (email confirmation still pending)
  final String? accessToken;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    this.accessToken,
  });

  bool get hasSession => accessToken != null;

  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  factory AuthUserModel.fromUser(User user, Session? session) {
    final meta = user.userMetadata ?? {};
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      name: (meta['name'] ?? meta['full_name'] ?? '').toString(),
      accessToken: session?.accessToken,
    );
  }
}
