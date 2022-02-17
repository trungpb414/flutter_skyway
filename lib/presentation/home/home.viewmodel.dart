import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:mobx/mobx.dart';

import '../app/app.pages.dart';
import 'home.suc.dart';

part 'home.viewmodel.g.dart';

enum CallModeType { sfu, mesh }
class HomeViewModel = _HomeViewModel with _$HomeViewModel;

abstract class _HomeViewModel extends BaseViewModel with Store {
  HomeSceneUseCaseType useCase;

  _HomeViewModel(this.useCase);

  @observable
  String roomName = "";

  @observable
  CallModeType callMode = CallModeType.sfu;

  final formKey = GlobalKey<FormState>();
  bool get isFormValid => formKey.currentState?.validate() ?? false;

  @override
  void onInit() async {
    super.onInit();
    (await useCase.getUsers()).when(
      success: print,
      failure: print,
    );
  }

  @action
  toHostVideoChat() {
    if (isFormValid) {
      Get.toNamed(Routes.VIDEO_CHAT);
    }
  }

  @action
  toJoinVideoChat() {
    if (isFormValid) {
      Get.toNamed(Routes.VIDEO_CHAT);
    }
  }

  @action
  setCallModeType(CallModeType callModeType) {
    callMode = callModeType;
  }

  @action
  String? roomNameValidator(String? value) =>
      (value == null || value.isEmpty || value.length > 20) ? "Invalid" : null;
}
