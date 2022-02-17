import 'dart:async';

import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/utils/constants.dart';

class SkywayUseCase {
  Future<SkywayPeer> connect(
      String apiKey, String domain, OnSkywayEventCallback onEvent) async {
    print("connect:");
    final String peerId = await channel.invokeMethod('connect', {
      'apiKey': apiKey,
      'domain': domain,
    });
    print('peerId: $peerId');
    return SkywayPeer(peerId: peerId, onEvent: onEvent)..initialize();
  }
}
