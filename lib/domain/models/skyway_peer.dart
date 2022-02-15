import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_skyway/utils/constants.dart';

typedef OnSkywayEventCallback = void Function(
    SkywayEvent event, Map<dynamic, dynamic> args);

class SkywayPeer {
  final String peerId;
  final OnSkywayEventCallback onEvent;
  StreamSubscription<dynamic>? _eventSubscription;

  SkywayPeer({required this.peerId, required this.onEvent});

  void initialize() {
    print("initialize:peerId=$peerId");
    _eventSubscription = EventChannel(PEER_EVENT_CHANNEL_NAME + '_$peerId')
        .receiveBroadcastStream()
        .listen(_eventListener, onError: _errorListener);
  }

  Future<void> disconnect() async {
    print("destroy:");
    _eventSubscription?.cancel();
    return await channel.invokeMethod('disconnect', {
      'peerId': peerId,
    });
  }

  Future<List<String>> listAllPeers() async {
    print("listAllPeers:");
    List<dynamic> peers = await channel.invokeMethod('listAllPeers', {
      'peerId': peerId,
    });
    return peers.cast<String>();
  }

  Future<void> startLocalStream(int localVideoId) async {
    print("startLocalStream:");
    return await channel.invokeMethod('startLocalStream', {
      'peerId': peerId,
      'localVideoId': localVideoId,
    });
  }

  Future<void> startRemoteStream(int remoteVideoId, String targetPeerId) async {
    print("startLocalStream:");
    return await channel.invokeMethod('startRemoteStream', {
      'peerId': peerId,
      'remoteVideoId': remoteVideoId,
      'remotePeerId': targetPeerId,
    });
  }

  Future<void> hangUp() async {
    print("hangUp:");
    return await channel.invokeMethod('hangUp', {
      'peerId': peerId,
    });
  }

  Future<void> call(String targetPeerId) async {
    print("call:");
    return await channel.invokeMethod('call', {
      'peerId': peerId,
      'remotePeerId': targetPeerId,
    });
  }

  Future<void> join(String room, SkywayRoomMode mode) async {
    print("join:room=$room,mode=$mode");
    return await channel.invokeMethod('join', {
      'peerId': peerId,
      'room': room,
      "mode": mode.index,
    });
  }

  Future<void> leave(String room) async {
    print("leave:");
    return await channel.invokeMethod('leave', {
      'peerId': peerId,
      'room': room,
    });
  }

  Future<void> accept(String remotePeerId) async {
    print("accept:");
    return await channel.invokeMethod('accept', {
      'peerId': peerId,
      'remotePeerId': remotePeerId,
    });
  }

  Future<void> reject(String remotePeerId) async {
    print("reject:");
    return await channel.invokeMethod('reject', {
      'peerId': peerId,
      'remotePeerId': remotePeerId,
    });
  }

  Future<void> switchCamera(CameraMode mode) async {
    print("switchCamera:");
    return await channel.invokeMethod('switchCamera', {
      'peerId': peerId,
      'mode': mode.index,
    });
  }

  void _eventListener(dynamic event) {
    print("_eventListener:$event");
    final Map<dynamic, dynamic> args = event;

    String _event = args['event'];
    if (peerId == args['peerId']) {
      switch (_event) {
        case 'onConnect':
          onEvent(SkywayEvent.onConnect, args);
          break;
        case 'onDisconnect':
          onEvent(SkywayEvent.onDisconnect, args);
          break;
        case 'onCall':
          onEvent(SkywayEvent.onCall, args);
          break;
        case 'onAddRemoteStream':
          onEvent(SkywayEvent.onAddRemoteStream, args);
          break;
        case 'onRemoveRemoteStream':
          onEvent(SkywayEvent.onRemoveRemoteStream, args);
          break;
        case 'onOpenRoom':
          onEvent(SkywayEvent.onOpenRoom, args);
          break;
        case 'onCloseRoom':
          onEvent(SkywayEvent.onCloseRoom, args);
          break;
        case 'onJoin':
          onEvent(SkywayEvent.onJoin, args);
          break;
        case 'onLeave':
          onEvent(SkywayEvent.onLeave, args);
          break;
        default:
          print('unknown event($_event),args=$args');
          break;
      }
    } else {
      print('Unexpected peer id');
    }
  }

  void _errorListener(Object obj) {
    print("_eventListener:$obj");
    print('onError: $obj');
  }
}
