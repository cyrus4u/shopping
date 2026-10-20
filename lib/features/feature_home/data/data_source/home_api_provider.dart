import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';



class HomeApiProvider {
  final SupabaseClient _client;
  HomeApiProvider(this._client);

  /// lat/lon stay in the signature so the repository and cubit don't change.
  /// get_home() doesn't use them yet (nearShops is an empty list).
  Future<Map<String, dynamic>> callHomeData(lat, lon) async {
    final response = await _client.rpc('get_home');
    log(response.toString());
    return Map<String, dynamic>.from(response as Map);
  }
}