import 'package:flutter_skyway/presentation/video_chat/video_chat.viewmodel.dart';
import 'package:get/get.dart';

class VideoChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<VideoChatViewModel>(VideoChatViewModel());
  }
}