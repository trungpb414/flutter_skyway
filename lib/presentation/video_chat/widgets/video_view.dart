part of '../video_chat.view.dart';

extension BuildVideoView on VideoChatView {
  Widget _buildLocalVideo() {
    if (Platform.isIOS) {
      return UiKitView(
        key: _localVideoKey,
        viewType: 'flutter.skyway/video_view',
        onPlatformViewCreated: viewModel.onLocalViewCreated,
      );
    } else if (Platform.isAndroid) {
      return SkywayCanvasView(
        key: _localVideoKey,
        onViewCreated: viewModel.onLocalViewCreated,
      );
    } else {
      throw UnsupportedError("unsupported platform");
    }
  }

  Widget _createRemoteView(String remotePeerId) {
    if (Platform.isIOS) {
      return UiKitView(
        key: ValueKey('remoteVideo$remotePeerId'),
        viewType: 'flutter.skyway/video_view',
        onPlatformViewCreated: (id) {
          viewModel.onRemoteViewCreated(remotePeerId, id);
        },
      );
    } else if (Platform.isAndroid) {
      return SkywayCanvasView(
        key: ValueKey('remoteVideo$remotePeerId'),
        onViewCreated: (id) {
          viewModel.onRemoteViewCreated(remotePeerId, id);
        },
      );
    } else {
      throw UnsupportedError("unsupported platform");
    }
  }
}
