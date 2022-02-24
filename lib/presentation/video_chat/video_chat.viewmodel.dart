import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/presentation/app/app.pages.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/group_chat.viewmodel.dart';
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
  ObservableList<IncomingPeopleNotification> notifications = ObservableList();

  VideoChatSceneUseCaseType useCase;

  _VideoChatViewModel(this.useCase);

  @observable
  SkywayPeer? peer;

  SkywayPeer? screenPeer;

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

  @observable
  bool isCameraEnabled = true;

  @observable
  bool isAudioEnabled = true;

  @observable
  int indexFullScreenVideo = 0;

  @observable
  bool isFullScreenEnabled = false;

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
  rotateCameraTrigger() {
    peer?.switchCamera();
  }

  @action
  toggleCameraTrigger() {
    peer?.setEnableVideoTrack(!isCameraEnabled);
    isCameraEnabled = !isCameraEnabled;
  }

  @action
  toggleMicTrigger() {
    peer?.setEnableAudioTrack(!isAudioEnabled);
    isAudioEnabled = !isAudioEnabled;
  }

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
  increaseNotification(String remotePeerId) async {
    notifications.add(
      IncomingPeopleNotification(
          circleImage: Assets.images.imgAvatarPlaceHolder.image(),
          name: "#remotePeerId $remotePeerId"),
    );
    await Future.delayed(
      const Duration(seconds: 5),
      () async {
        notifications.removeAt(0);
      },
    );
  }

  @action
  bool checkVisibilityByIndex(int currentIndex) {
    return currentIndex == indexFullScreenVideo || indexFullScreenVideo == 0;
  }

  @action
  setIndexFullScreenVideo(int value) {
    indexFullScreenVideo = value;
    isFullScreenEnabled = true;
  }

  @action
  disableFullscreenVideoMode() {
    indexFullScreenVideo = 0;
    isFullScreenEnabled = false;
  }

  @override
  void onClose() async {
    super.onClose();
    await peer?.disconnect();
    await screenPeer?.disconnect();
  }

  void shareTrigger() async {
    try {
      await peer?.requestShareScreenPermission();
      screenPeer = await useCase.connect("b4c7675c-056e-47cb-a9ec-2a0f9f4904c2",
          "localhost", _onShareSkywayEvent);
      await screenPeer?.joinAsScreen(roomName, SkywayRoomMode.SFU);
    } on Exception catch (e) {
      print(e);
    }
  }

  void _onShareSkywayEvent(SkywayEvent event, Map<dynamic, dynamic> args) {}

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
      case SkywayEvent.onMessageData:
        _onMessageData(args['message']);
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
    increaseNotification(remotePeerId);
  }

  void _onLeave(String remotePeerId) {
    print('_onLeave:remotePeerId=$remotePeerId');
  }

  void _onMessageData(String message) {
    print('_onMessageData:message=$message');
    try {
      var chatVM = Get.find<GroupChatViewModel>();
      chatVM.onMessageReceived(message);
    } catch (e) {
      print(e);
    }
  }

  void goToChat() {
    Get.toNamed(Routes.GROUP_CHAT);
  }

  void showSetting() {
    Get.bottomSheet(
        SettingBottomSheet(
          onRecordSelected: () {},
          onShareSelected: () {
            shareTrigger();
          },
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
