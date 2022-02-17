import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppDio with DioMixin implements Dio {
  static AppDio getInstance() => AppDio._();

  AppDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: "",
      contentType: 'application/json',
      connectTimeout: 10000,
      sendTimeout: 10000,
      receiveTimeout: 10000,
    );

    this.options = options;

    interceptors.add(PrettyDioLogger());

    httpClientAdapter = DefaultHttpClientAdapter();
  }
}
