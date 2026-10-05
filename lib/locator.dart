import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/common/utils/prefs_operator.dart';

GetIt locator = GetIt.instance;
Future<void> initLocator() async {

  locator.registerSingleton<Dio>(Dio());

  SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPrefrences);
  locator.registerSingleton<PrefsOperator>(PrefsOperator());
}
