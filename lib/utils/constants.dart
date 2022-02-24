import 'package:flutter/services.dart';

const String METHOD_CHANNEL_NAME = "flutter.skyway/method";
const String PEER_EVENT_CHANNEL_NAME = "flutter.skyway/event";
const String SKYWAY_CANVAS_VIEW = "flutter.skyway/canvas";

const MethodChannel channel = MethodChannel(METHOD_CHANNEL_NAME);

enum SkywayEvent {
  onConnect,
  onDisconnect,
  onCall,
  onAddRemoteStream,
  onRemoveRemoteStream,
  onOpenRoom,
  onCloseRoom,
  onJoin,
  onLeave,
  onRelease,
  onMessageData
}

enum SkywayRoomMode {
  Mesh,
  SFU,
}

enum CameraMode {
  UNSPECIFIED,
  FRONT,
  BACK,
}
