import 'package:flutter/material.dart';
import 'package:flutter_skyway/presentation/app/app.pages.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/end_call_aleartdialog.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/setting_bottomsheet.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.suc.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';

import '../../domain/entities/skyway_peer.dart';
import '../../utils/constants.dart';

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

  @action
  rotateCameraTrigger() {}

  @action
  toggleCameraTrigger() {}

  @action
  toggleMicTrigger() {}

  @action
  declineTrigger(BuildContext context) {
    showAlertDialog(context);
  }

  @override
  void onClose() {
    super.onClose();
    peer?.disconnect();
  }

  void _onSkywayEvent(SkywayEvent event, Map<dynamic, dynamic> args) {
    print(event);
  }

  void goToChat() {
    Get.toNamed(Routes.GROUP_CHAT);
  }

  void showSetting(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      builder: (BuildContext context) {
        return SettingBottomSheet(
          onRecordSelected: () {},
          onShareSelected: () {},
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => EndCallDialog(
              onEndCall: () {
                Get.back();
              },
            ));
  }
}
