import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopping/config/app_logger.dart';

class HomeApiProvider {
  static const _tag = 'HomeApi';

  final SupabaseClient _client;
  HomeApiProvider(this._client);

  /// lat/lon stay in the signature so the repository and cubit don't change.
  /// get_home() doesn't use them yet (nearShops is an empty list).
  Future<Map<String, dynamic>> callHomeData(double lat, double lon) async {
    try {
      final response = await _client.rpc('get_home');
      AppLogger.info('get_home loaded', name: _tag);
      return Map<String, dynamic>.from(response as Map);
    } on PostgrestException catch (e, st) {
      // Supabase/database error (wrong function name, RLS, SQL error...)
      AppLogger.error(
        'get_home failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    } catch (e, st) {
      // Anything else (no internet, wrong response type...)
      AppLogger.error(
        'Unexpected error in get_home',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }
}

// class HomeApiProvider {
//   final SupabaseClient _client;
//   HomeApiProvider(this._client);

//   /// lat/lon stay in the signature so the repository and cubit don't change.
//   /// get_home() doesn't use them yet (nearShops is an empty list).
//   Future<Map<String, dynamic>> callHomeData(lat, lon) async {
//     final response = await _client.rpc('get_home');
//     log(response.toString());
//     return Map<String, dynamic>.from(response as Map);
//   }
// }