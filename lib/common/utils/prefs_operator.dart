import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../locator.dart';

class PrefsOperator {
  late final SharedPreferences sharedPreferences;

  PrefsOperator() {
    sharedPreferences = locator<SharedPreferences>();
  }

  /// Display data only. The real session lives in Supabase.
  /// (Signature kept so both auth screens still compile; the token is
  /// no longer needed and `mobile` now holds the email.)
  Future<void> saveUserData(String token, String userName, String mobile) async {
    await sharedPreferences.setString("user_token", token);
    await sharedPreferences.setString("user_name", userName);
    await sharedPreferences.setString("user_mobile", mobile);
    await sharedPreferences.setBool("loggedIn", true);
  }

  Future<String?> getUserToken() async {
    return sharedPreferences.getString('user_token');
  }

  Future<void> changeIntroState() async {
    await sharedPreferences.setBool("showIntro", false);
  }

  Future<bool> getIntroState() async {
    return sharedPreferences.getBool("showIntro") ?? true;
  }

  /// Source of truth is the Supabase session, not a local flag.
  Future<bool> getLoggedIn() async {
    return locator<SupabaseClient>().auth.currentSession != null;
  }

  Future<void> logout() async {
    await locator<SupabaseClient>().auth.signOut();
    await sharedPreferences.clear();
    await sharedPreferences.setBool("showIntro", false);
  }
}