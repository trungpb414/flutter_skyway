import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';

part 'video_chat.viewmodel.g.dart';

class VideoChatViewModel = _VideoChatViewModel with _$VideoChatViewModel;

abstract class _VideoChatViewModel extends BaseViewModel with Store {
  @observable int value = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @action increment() => value += 1;
}