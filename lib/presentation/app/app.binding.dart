import 'package:flutter_skyway/presentation/app/app.viewmodel.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AppViewModel>(AppViewModel());
  }
}