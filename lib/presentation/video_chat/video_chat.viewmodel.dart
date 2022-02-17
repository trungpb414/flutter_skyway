import 'package:flutter/services.dart';
import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.suc.dart';
import 'package:flutter_skyway/utils/constants.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';

part 'video_chat.viewmodel.g.dart';

class VideoChatViewModel = _VideoChatViewModel with _$VideoChatViewModel;

abstract class _VideoChatViewModel extends BaseViewModel with Store {
  VideoChatSceneUseCaseType useCase;

  _VideoChatViewModel(this.useCase);

  SkywayPeer? peer;

  @override
  void onInit() async {
    super.onInit();
    try {
      // peer = await useCase.connect("b4c7675c-056e-47cb-a9ec-2a0f9f4904c2", "localhost11", _onSkywayEvent);
    } on Exception catch (e) {
      Get.defaultDialog(title: "Error", middleText: e.toString());
    }
  }

  @override
  void onClose() {
    super.onClose();
    peer?.disconnect();
  }

  void _onSkywayEvent(SkywayEvent event, Map<dynamic, dynamic> args) {
    print(event);
  }
}