import 'package:dio/dio.dart';
import 'package:flutter_skyway/data/api/api_services.dart';
import 'package:flutter_skyway/data/api/news_data_source.dart';
import 'package:flutter_skyway/data/repositories/user_repository.dart';
import 'package:flutter_skyway/presentation/app/app.viewmodel.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AppDio>(AppDio.getInstance(), permanent: true);
    Get.lazyPut<UsersDataSource>(() => UsersDataSource());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.put<AppViewModel>(AppViewModel());
  }
}