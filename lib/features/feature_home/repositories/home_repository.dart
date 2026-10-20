import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/features/feature_home/data/data_source/home_api_provider.dart';
import 'package:shopping/features/feature_home/data/models/home_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart'; // for debugPrint

class HomeRepository {
  HomeApiProvider apiProvider;
  HomeRepository(this.apiProvider);

  Future<DataState<HomeModel>> fetchHomeData(lat, lon) async {
    try {
      final Map<String, dynamic> json = await apiProvider.callHomeData(lat, lon);
      return DataSuccess(HomeModel.fromJson(json));
    } on PostgrestException catch (e) {
      debugPrint('get_home failed: code=${e.code} message=${e.message} details=${e.details} hint=${e.hint}');
      return DataFailed('Server error: ${e.message}');
    } catch (e, st) {
      debugPrint('fetchHomeData failed: $e\n$st');
      return DataFailed('Could not load data. Please check your connection.');
    }
  }
}