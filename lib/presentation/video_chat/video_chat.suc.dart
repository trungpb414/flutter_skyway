import 'package:flutter_skyway/domain/entities/skyway_peer.dart';
import 'package:flutter_skyway/domain/use_case/skyway.uc.dart';

abstract class VideoChatSceneUseCaseType {
  Future<SkywayPeer> connect(
      String apiKey, String domain, OnSkywayEventCallback onEvent);
}

class VideoChatSceneUseCase with SkywayUseCase implements VideoChatSceneUseCaseType {}