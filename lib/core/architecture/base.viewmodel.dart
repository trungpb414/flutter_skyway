import 'package:get/get.dart';

abstract class BaseViewModel extends GetxController {
  @override
  void dispose() {
    Get.log('"${runtimeType.toString()}" disposed');
    super.dispose();
  }
}