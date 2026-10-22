import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shopping/common/error_handling/check_exceptions.dart';
import 'package:shopping/config/constants.dart';

class CategoryApiProvider {
  Dio dio;
  CategoryApiProvider(this.dio);

  dynamic callCategories() async {
    try {
      final response = await dio.get('${Constants.baseUrl}/categories/tree');
      log(response.toString());
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response!);
    }
  }
}
