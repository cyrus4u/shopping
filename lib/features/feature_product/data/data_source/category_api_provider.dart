import 'package:shopping/config/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryApiProvider {
  static const _tag = 'CategoryApi';

  final SupabaseClient _client;
  CategoryApiProvider(this._client);

  Future<Map<String, dynamic>> callCategories() async {
    try {
      final response = await _client.rpc('get_categories_tree');
      AppLogger.info('get_categories_tree loaded', name: _tag);
      return Map<String, dynamic>.from(response as Map);
    } on PostgrestException catch (e, st) {
      AppLogger.error(
        'get_categories_tree failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Unexpected error in get_categories_tree',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }
}