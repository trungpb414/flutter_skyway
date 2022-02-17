import 'package:flutter/material.dart';
import 'package:flutter_skyway/presentation/group_chat/message_model.dart';
import 'package:flutter_skyway/presentation/group_chat/user_model.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_skyway/core/base.dart';

part 'group_chat.viewmodel.g.dart';

class GroupChatViewModel = _GroupChatViewModel with _$GroupChatViewModel;

abstract class _GroupChatViewModel extends BaseViewModel with Store {
  @observable
  List<UserModel> users = [];

  @observable
  List<MessageModel> messages = [];

  late TextEditingController messageController;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();

    users = [
      UserModel(id: 1, name: 'user1', avatar: 'assets/images/pic1.jpg'),
      UserModel(id: 2, name: 'user2', avatar: 'assets/images/pic2.jpg'),
      UserModel(id: 3, name: 'user3', avatar: 'assets/images/pic3.jpg'),
    ];

    messages = [
      MessageModel(
          id: 1,
          content: 'message message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 8)),
          userSentId: 1),
      MessageModel(
          id: 2,
          content: 'messagemessage message ',
          time: DateTime.now().subtract(const Duration(minutes: 7)),
          userSentId: 2),
      MessageModel(
          id: 3,
          content: 'message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 6)),
          userSentId: 2),
      MessageModel(
          id: 4,
          content: 'message message ',
          time: DateTime.now().subtract(const Duration(minutes: 5)),
          userSentId: 3),
      MessageModel(
          id: 5,
          content: 'messagemessage message message ',
          time: DateTime.now().subtract(const Duration(minutes: 4)),
          userSentId: 1),
      MessageModel(
          id: 6,
          content: 'message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 3)),
          userSentId: 1),
      MessageModel(
          id: 7,
          content: 'message message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 2)),
          userSentId: 3),
      MessageModel(
          id: 8,
          content: 'message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 2)),
          userSentId: 3),
      MessageModel(
          id: 1,
          content: 'message message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 1),
      MessageModel(
          id: 2,
          content: 'messagemessage message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 2),
      MessageModel(
          id: 3,
          content: 'message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 2),
      MessageModel(
          id: 1,
          content: 'message message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 1),
      MessageModel(
          id: 2,
          content: 'messagemessage message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 2),
      MessageModel(
          id: 3,
          content: 'message message message message message ',
          time: DateTime.now().subtract(const Duration(minutes: 1)),
          userSentId: 2),
    ].reversed.toList();
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
    }
    messageController.clear();
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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

  String getCallTime() {
    return DateFormat('dd.MM.yyyy').format(DateTime.now());
  }
}
