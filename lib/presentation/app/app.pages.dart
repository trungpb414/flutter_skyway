// ignore_for_file: constant_identifier_names
import 'package:flutter_skyway/presentation/app/app.binding.dart';
import 'package:flutter_skyway/presentation/app/app.view.dart';
import 'package:flutter_skyway/presentation/group_chat/group_chat.binding.dart';
import 'package:flutter_skyway/presentation/group_chat/group_chat.view.dart';
import 'package:flutter_skyway/presentation/home/home.binding.dart';
import 'package:flutter_skyway/presentation/home/home.view.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.binding.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.view.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const HOME = '/home';
  static const VIDEO_CHAT = '/video_chat';
  static const GROUP_CHAT = '/group_chat';
}

class AppPages {
  static const INITIAL = Routes.INITIAL;

  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const AppView(),
      bindings: [AppBinding()],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: Routes.VIDEO_CHAT,
      page: () => const VideoChatView(),
      bindings: [VideoChatBinding()],
    ),
    GetPage(
      name: Routes.GROUP_CHAT,
      page: () => GroupChatView(),
      bindings: [GroupChatBinding()],
    ),
  ];
}
