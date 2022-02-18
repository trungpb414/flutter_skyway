import 'package:flutter_skyway/presentation/video_chat/group_chat/group_chat.viewmodel.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.viewmodel.dart';
import 'package:get/get.dart';

class GroupChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupChatViewModel>(() => GroupChatViewModel());
  }
}