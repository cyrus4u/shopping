import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:shopping/features/feature_product/data/data_source/category_api_provider.dart';
import 'package:shopping/features/feature_product/data/models/categories_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final CategoryApiProvider apiProvider;
  CategoryRepository(this.apiProvider);

  Future<DataState<CategoriesModel>> fetchCategoryData() async {
    try {
      final json = await apiProvider.callCategories();
      return DataSuccess(CategoriesModel.fromJson(json));
    } on PostgrestException catch (e) {
      return DataFailed('Server error: ${e.message}');
    } catch (e, st) {
      AppLogger.error(
        'fetchCategoryData failed',
        error: e,
        stackTrace: st,
        name: 'CategoryRepository',
      );
      return DataFailed('Something went wrong. Please try again.');
    }
  }
}