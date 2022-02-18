import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/presentation/app/app.pages.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';

part 'app.viewmodel.g.dart';

class AppViewModel = _AppViewModel with _$AppViewModel;

abstract class _AppViewModel extends BaseViewModel with Store {
  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 1), () async {
      await Get.toNamed(Routes.HOME);
    });
  }
}
