import 'package:flutter/material.dart';
import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/message_model.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/end_call_aleartdialog.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/setting_bottomsheet.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.viewmodel.dart';
import 'package:flutter_skyway/utils/constants.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:get/get.dart';

part 'group_chat.viewmodel.g.dart';

class GroupChatViewModel = _GroupChatViewModel with _$GroupChatViewModel;

abstract class _GroupChatViewModel extends BaseViewModel with Store {
  @observable
  List<User> users = [];

  @observable
  List<MessageModel> messages = [];

  late TextEditingController messageController;

  final ScrollController scrollController = ScrollController();

  final callTime = DateFormat('dd.MM.yyyy').format(DateTime.now());

  final videoVM = Get.find<VideoChatViewModel>();

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();

    users = [
      User(
          id: '1',
          firstName: 'Lan',
          lastName: 'Tran',
          picture: Assets.images.pic1.path),
      User(
          id: '2',
          firstName: 'Hoa',
          lastName: 'Nguyen',
          picture: Assets.images.pic2.path),
      User(
          id: '3',
          firstName: 'Hue',
          lastName: 'Vo',
          picture: Assets.images.pic3.path),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @action
  void addMessage() {
    if (messageController.text.isNotEmpty) {
      messages = [
        MessageModel(
          content: messageController.text,
          time: DateTime.now(),
          userSentId: 1,
        ),
        ...messages
      ];
      if (videoVM.peer != null) {
        videoVM.peer!.sendText(videoVM.roomName, messageController.text);
      }
    }
    messageController.clear();
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @action
  void onMessageReceived(String text) {
    messages = [
      MessageModel(
        content: text,
        time: DateTime.now(),
        userSentId: 2,
      ),
      ...messages
    ];
  }

  bool hasAvatar(int index) {
    if (index == 0) {
      return true;
    }
    if (messages[index].userSentId != messages[index - 1].userSentId) {
      return true;
    }
    return false;
  }

  void backToVideo() {
    Get.back();
  }

  void showSetting() {
    Get.bottomSheet(
        SettingBottomSheet(
          onRecordSelected: () {},
          onShareSelected: () {},
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white);
  }
}
