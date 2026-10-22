import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:shopping/features/feature_home/data/data_source/home_api_provider.dart';
import 'package:shopping/features/feature_home/data/models/home_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepository {
  final HomeApiProvider apiProvider;
  HomeRepository(this.apiProvider);

  Future<DataState<HomeModel>> fetchHomeData(double lat, double lon) async {
    try {
      final json = await apiProvider.callHomeData(lat, lon);
      return DataSuccess(HomeModel.fromJson(json));
    } on PostgrestException catch (e) {
      return DataFailed('Server error: ${e.message}');
    } catch (e, st) {
      AppLogger.error(
        'fetchHomeData failed',
        error: e,
        stackTrace: st,
        name: 'HomeRepository',
      );
      return DataFailed('Something went wrong. Please try again.');
    }
  }
}
