import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/presentation/home/home.suc.dart';
import 'package:mobx/mobx.dart';

part 'home.viewmodel.g.dart';

class HomeViewModel = _HomeViewModel with _$HomeViewModel;

abstract class _HomeViewModel extends BaseViewModel with Store {
  HomeSceneUseCaseType useCase;

  _HomeViewModel(this.useCase);

  @observable
  int value = 0;

  @override
  void onInit() async {
    super.onInit();
    (await useCase.getUsers()).when(
      success: print,
      failure: print,
    );
  }

  @action
  increment() => value += 1;
}
