import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/features/feature_home/data/data_source/home_api_provider.dart';
import 'package:shopping/features/feature_home/repositories/home_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt locator = GetIt.instance;
Future<void> initLocator() async {
  locator.registerSingleton<Dio>(Dio());
  
  // Supabase client (Supabase.initialize already ran in main.dart)
  locator.registerSingleton<SupabaseClient>(Supabase.instance.client);

  SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPrefrences);
  locator.registerSingleton<PrefsOperator>(PrefsOperator());

  /// api provider
  locator.registerSingleton<HomeApiProvider>(HomeApiProvider(locator()));

  /// repository
  locator.registerSingleton<HomeRepository>(HomeRepository(locator()));
}
