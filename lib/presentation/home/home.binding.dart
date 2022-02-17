import 'package:flutter_skyway/mock/usecase/home.suc.mock.dart';
import 'package:flutter_skyway/presentation/home/home.suc.dart';
import 'package:flutter_skyway/presentation/home/home.viewmodel.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    bool isMock = false;
    Get.put<HomeViewModel>(
        HomeViewModel(isMock ? HomeSceneUseCaseMock() : HomeSceneUseCase()));
  }
}
