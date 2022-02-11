import 'package:flutter_skyway/core/base.dart';
import 'package:mobx/mobx.dart';

part 'home.viewmodel.g.dart';

class HomeViewModel = _HomeViewModel with _$HomeViewModel;

abstract class _HomeViewModel extends BaseViewModel with Store {
  @observable int value = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @action increment() => value += 1;
}