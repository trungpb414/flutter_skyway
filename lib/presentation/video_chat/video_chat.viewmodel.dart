import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/presentation/app/app.pages.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/end_call_aleartdialog.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/widgets/setting_bottomsheet.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.suc.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/skyway_peer.dart';
import '../../utils/constants.dart';
import '../app/app.pages.dart';
import 'group_chat/widgets/end_call_aleartdialog.dart';
import 'group_chat/widgets/setting_bottomsheet.dart';

part 'video_chat.viewmodel.g.dart';

class VideoChatViewModel = _VideoChatViewModel with _$VideoChatViewModel;

class RemotePeer {
  bool hasRemoteStream = false;
}

abstract class _VideoChatViewModel extends BaseViewModel with Store {
  @observable
  int numberOfPeople = 4;

  ObservableList<IncomingPeopleNotification> notifications = ObservableList();

  VideoChatSceneUseCaseType useCase;

  _VideoChatViewModel(this.useCase);

  @observable
  SkywayPeer? peer;

  @computed
  bool get isConnected => peer != null;

  bool get isTalking => (peer != null) && peers.isNotEmpty;

  @observable
  bool isJoined = false;

  @observable
  String roomName = "";

  @computed
  int get totalRemotePeer => peers.length;

  @observable
  ObservableMap<String, RemotePeer> peers = ObservableMap();
  @override
  void onInit() async {
    super.onInit();
    roomName = Get.arguments as String;
    try {
      await checkPermission();
      if (await checkPermission()) {
        peer = await useCase.connect("b4c7675c-056e-47cb-a9ec-2a0f9f4904c2",
            "localhost", _onSkywayEvent);
      } else {}
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
  declineTrigger() {
    Get.dialog(
      EndCallDialog(
        onEndCall: () {
          peer?.disconnect();
          Get.back();
        },
      ),
    );
  }

  @action
  increaseNotification() async {
    numberOfPeople = (numberOfPeople + 1) % 4 + 1;
    notifications.add(
      IncomingPeopleNotification(
          circleImage: Assets.images.imgAvatarPlaceHolder.image(),
          name: "John ${notifications.length + 1}"),
    );
    await Future.delayed(
      const Duration(seconds: 2),
      () async {
        notifications.removeAt(0);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    peer?.disconnect();
  }

  Future<bool> checkPermission() async {
    var cameraStatus = await Permission.camera.status;
    var micStatus = await Permission.microphone.status;
    if (cameraStatus.isDenied || micStatus.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
    }
    return cameraStatus.isGranted && micStatus.isGranted;
  }

  Future<void> onLocalViewCreated(int id) async {
    if (isConnected) {
      print("onLocalViewCreated $id");
      await peer?.startLocalStream(id);
      if (roomName.isNotEmpty && !isJoined) enter(roomName);
    }
  }

  Future<void> onRemoteViewCreated(String remotePeerId, int id) async {
    if (isTalking && peers.containsKey(remotePeerId)) {
      await peer?.startRemoteStream(id, remotePeerId);
    }
    peers[remotePeerId]?.hasRemoteStream = true;
  }

  Future<void> enter(String roomName) async {
    await peer?.join(roomName, SkywayRoomMode.SFU);
  }

  void _onSkywayEvent(SkywayEvent event, Map<dynamic, dynamic> args) {
    switch (event) {
      case SkywayEvent.onConnect:
        _onConnect(args['peerId']);
        break;
      case SkywayEvent.onDisconnect:
        _onDisconnect(args['peerId']);
        break;
      case SkywayEvent.onAddRemoteStream:
        _onAddRemoteStream(args['remotePeerId']);
        break;
      case SkywayEvent.onRemoveRemoteStream:
        _onRemoveRemoteStream(args['remotePeerId']);
        break;
      case SkywayEvent.onOpenRoom:
        _onOpenRoom(args['room']);
        break;
      case SkywayEvent.onCloseRoom:
        _onCloseRoom(args['room']);
        break;
      case SkywayEvent.onJoin:
        _onJoin(args['remotePeerId']);
        break;
      case SkywayEvent.onLeave:
        _onLeave(args['remotePeerId']);
        break;
      case SkywayEvent.onCall:
        break;
    }
  }

  void _onConnect(String peerId) {
    print('_onConnect:peerId=$peerId');
  }

  void _onDisconnect(String peerId) {
    print('_onConnect:peerId=$peerId');
    isJoined = false;
    Get.back();
  }

  void _onAddRemoteStream(String remotePeerId) {
    print('_onAddRemoteStream:remotePeerId=$remotePeerId');
    peers[remotePeerId] = RemotePeer();
  }

  void _onRemoveRemoteStream(String remotePeerId) {
    print('_onRemoveRemoteStream:remotePeerId=$remotePeerId');
    peers.remove(remotePeerId);
  }

  void _onOpenRoom(String room) {
    print('_onOpenRoom:room=$room');
    isJoined = true;
  }

  void _onCloseRoom(String room) {
    print('_onCloseRoom:room=$room');
    isJoined = false;
    Get.back();
  }

  void _onJoin(String remotePeerId) {
    print('_onJoin:remotePeerId=$remotePeerId');
  }

  void _onLeave(String remotePeerId) {
    print('_onLeave:remotePeerId=$remotePeerId');
  }

  void goToChat() {
    Get.toNamed(Routes.GROUP_CHAT);
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

class IncomingPeopleNotification {
  final Widget circleImage;
  final String name;

  IncomingPeopleNotification({required this.circleImage, required this.name});
}
