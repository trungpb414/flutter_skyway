part of '../../video_chat.view.dart';

extension BuildVideoChat4People on VideoChatView {
  Widget buildVideoChat4People() {
    return Column(
      children: [
        Visibility(
          visible: viewModel.checkVisibilityByIndex(1) ||
              viewModel.checkVisibilityByIndex(2),
          child: Expanded(
            child: Row(
              children: [
                Visibility(
                  visible: viewModel.checkVisibilityByIndex(1),
                  child: _buildItemVideoChat(
                    index: 1,
                    onDoubleTap: () {
                      viewModel.setIndexFullScreenVideo(1);
                    },
                    name: "You",
                    uiVideoChatView: _buildLocalVideo(),
                  ),
                ),
                Visibility(
                  visible: viewModel.checkVisibilityByIndex(2),
                  child: _buildItemVideoChat(
                    index: 2,
                    onDoubleTap: () {
                      viewModel.setIndexFullScreenVideo(2);
                    },
                    name: "User1",
                    uiVideoChatView:
                        _createRemoteView(viewModel.peers.keys.first),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: viewModel.checkVisibilityByIndex(3) ||
              viewModel.checkVisibilityByIndex(4),
          child: Expanded(
            child: Row(
              children: [
                Visibility(
                  visible: viewModel.checkVisibilityByIndex(3),
                  child: _buildItemVideoChat(
                    index: 3,
                    onDoubleTap: () {
                      viewModel.setIndexFullScreenVideo(3);
                    },
                    name: "User2",
                    uiVideoChatView:
                        _createRemoteView(viewModel.peers.keys.elementAt(1)),
                  ),
                ),
                Visibility(
                  visible: viewModel.checkVisibilityByIndex(4),
                  child: _buildItemVideoChat(
                    index: 4,
                    onDoubleTap: () {
                      viewModel.setIndexFullScreenVideo(4);
                    },
                    name: "User3",
                    uiVideoChatView:
                        _createRemoteView(viewModel.peers.keys.elementAt(2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemVideoChat(
      {required int index,
      required GestureDoubleTapCallback onDoubleTap,
      bool isLoading = false,
      required String name,
      required Widget uiVideoChatView}) {
    return Expanded(
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: uiVideoChatView,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name)
                          .defaultStyle()
                          .color(Colors.white)
                          .fontStyle(FontStyle.normal)
                          .fontWeight(FontWeight.w500)
                          .fontSize(14),
                      const SizedBox(
                        width: 6,
                      ),
                      Assets.images.icMicUnmute.svg(height: 16, width: 16),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 8,
                  ),
                  child: Assets.images.icDots.svg(height: 24, width: 24),
                ),
              ),
              Visibility(
                visible: viewModel.isLoading,
                child: const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      value: null,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: viewModel.checkVisibilityByIndex(index) &&
                    viewModel.isFullScreenEnabled,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: viewModel.disableFullscreenVideoMode,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.close, size: 48, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
