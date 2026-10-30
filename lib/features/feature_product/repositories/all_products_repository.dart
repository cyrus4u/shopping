import 'package:shopping/common/params/products_params.dart';
import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:shopping/features/feature_product/data/data_source/product_api_provider.dart';
import 'package:shopping/features/feature_product/data/models/all_products_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllProductsRepository {
  final ProductsApiProvider apiProvider;
  AllProductsRepository(this.apiProvider);

  Future<DataState<AllProductsModel>> fetchAllProductsData(
    ProductsParams productsParams,
  ) async {
    try {
      final json = await apiProvider.callAllProducts(productsParams);
      return DataSuccess(AllProductsModel.fromJson(json));
    } on PostgrestException catch (e) {
      return DataFailed('Server error: ${e.message}');
    } catch (e, st) {
      AppLogger.error(
        'fetchAllProductsData failed',
        error: e,
        stackTrace: st,
        name: 'AllProductsRepository',
      );
      return DataFailed('Something went wrong. Please try again.');
    }
  }

  /// Used by the search box. A failed search should show "no results",
  /// not crash the suggestion list.
  Future<List<Products>> fetchAllProductsDataSearch(
    ProductsParams productsParams,
  ) async {
    try {
      final json = await apiProvider.callAllProducts(productsParams);
      final model = AllProductsModel.fromJson(json);
      return model.data?.firstOrNull?.products ?? const [];
    } catch (e, st) {
      AppLogger.error(
        'fetchAllProductsDataSearch failed',
        error: e,
        stackTrace: st,
        name: 'AllProductsRepository',
      );
      return const [];
    }
  }
}