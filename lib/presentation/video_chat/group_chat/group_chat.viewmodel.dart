import 'package:flutter/material.dart';
import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/message_model.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.viewmodel.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:get/get.dart';

part 'group_chat.viewmodel.g.dart';

class GroupChatViewModel = _GroupChatViewModel with _$GroupChatViewModel;

abstract class _GroupChatViewModel extends BaseViewModel with Store {
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
  }

  @computed
  int get totalUsers => videoVM.users.length;

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @action
  void addMessage() {
    if (messageController.text.isNotEmpty && videoVM.peer != null) {
      messages = [
        MessageModel(
          content: messageController.text,
          time: DateTime.now(),
          userSentId: videoVM.peer?.peerId ?? '',
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
  void onMessageReceived(String message, String senderId) {
    messages = [
      MessageModel(
        content: message,
        time: DateTime.now(),
        userSentId: senderId,
      ),
      ...messages
    ];
  }

  @action
  bool checkIfIsSender(int index) =>
      messages[index].userSentId == videoVM.peer?.peerId;

  @action
  User getUser(int index) => videoVM.users
      .firstWhere((element) => element.id == messages[index].userSentId);

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

  void showSetting() {}
}
