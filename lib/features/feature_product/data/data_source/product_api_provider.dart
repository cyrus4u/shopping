import 'package:shopping/common/params/products_params.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsApiProvider {
  static const _tag = 'ProductsApi';

  final SupabaseClient _client;
  ProductsApiProvider(this._client);

  Future<Map<String, dynamic>> callAllProducts(
    ProductsParams productsParams,
  ) async {
    try {
      final response = await _client.rpc(
        'get_products',
        params: {
          'p_start': productsParams.start,
          'p_step': productsParams.step,
          'p_category': productsParams.categories,
          'p_min_price': productsParams.minPrice,
          'p_max_price': productsParams.maxPrice,
          'p_sort_by': productsParams.sortBy,
          'p_search': productsParams.search,
        },
      );
      return Map<String, dynamic>.from(response as Map);
    } on PostgrestException catch (e, st) {
      AppLogger.error(
        'get_products failed: ${e.message}',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'Unexpected error in get_products',
        error: e,
        stackTrace: st,
        name: _tag,
      );
      rethrow;
    }
  }
}