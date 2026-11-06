// lib/config/auth_config.dart
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthConfig {
  static const mobileScheme = 'io.supabase.shopping';
  static const mobileRedirect = '$mobileScheme://login-callback/';
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// Web returns to the site's own address (works on localhost and on a
  /// deployed domain, as long as that address is in Supabase's Redirect URLs).
  /// Phones return through the deep link set up in AndroidManifest.xml.
  static String get googleRedirect => kIsWeb ? Uri.base.origin : mobileRedirect;
}