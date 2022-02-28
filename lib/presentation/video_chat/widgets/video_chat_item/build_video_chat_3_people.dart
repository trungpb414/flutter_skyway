part of '../../video_chat.view.dart';

extension BuildVideoChat3People on VideoChatView {
  Widget buildVideoChat3People() {
    return Column(
      children: [
        Visibility(
          visible: viewModel.checkVisibilityByIndex(1),
          child: Expanded(
            flex: 1,
            child: GestureDetector(
              onDoubleTap: () {
                viewModel.setIndexFullScreenVideo(1);
              },
              child: SizedBox(
                height: 262,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildLocalVideo(),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                alignment: Alignment.center,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color(0xFFD4D4D4).withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("0:01")
                                        .defaultStyle()
                                        .fontSize(14)
                                        .fontWeight(FontWeight.w400)
                                        .color(Colors.white),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Assets.images.icLock
                                        .svg(height: 16, width: 16)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: const Text("You")
                              .defaultStyle()
                              .fontSize(14)
                              .fontWeight(FontWeight.w500)
                              .color(Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, right: 8),
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFD4D4D4).withOpacity(0.2),
                            ),
                            child:
                                Assets.images.icMask.svg(width: 20, height: 20),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: viewModel.checkVisibilityByIndex(1) &&
                            viewModel.isFullScreenEnabled,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: viewModel.disableFullscreenVideoMode,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.close,
                                  size: 48, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Visibility(
          visible: !viewModel.checkVisibilityByIndex(1) ||
              !viewModel.isFullScreenEnabled,
          child: Expanded(
            flex: 1,
            child: GestureDetector(
              onDoubleTap: () {
                viewModel.setIndexFullScreenVideo(2);
              },
              child: SizedBox(
                height: 284,
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: viewModel.checkVisibilityByIndex(2),
                          child: Expanded(
                            flex: 1,
                            child: SizedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(0xFF71E079),
                                        ),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: _createRemoteView(
                                              viewModel.peers.keys.first)),
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          right: 8,
                                        ),
                                        child: Assets.images.icDots
                                            .svg(height: 24, width: 24),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text("User 1")
                                            .defaultStyle()
                                            .fontSize(14)
                                            .fontWeight(FontWeight.w500)
                                            .color(Colors.white),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          viewModel.checkVisibilityByIndex(2) &&
                                              viewModel.isFullScreenEnabled,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: viewModel
                                              .disableFullscreenVideoMode,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Icons.close,
                                                size: 48, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: viewModel.checkVisibilityByIndex(3),
                          child: Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onDoubleTap: () {
                                viewModel.setIndexFullScreenVideo(3);
                              },
                              child: SizedBox(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: _createRemoteView(
                                              viewModel.peers.keys.last)),
                                      Container(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                            right: 8,
                                          ),
                                          child: Assets.images.icDots
                                              .svg(height: 24, width: 24),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("User 2")
                                                  .defaultStyle()
                                                  .fontSize(14)
                                                  .fontWeight(FontWeight.w500)
                                                  .color(Colors.white),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Assets.images.icMicUnmute
                                                  .svg(height: 16, width: 16),
                                            ],
                                          ),
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
                                        visible: viewModel
                                                .checkVisibilityByIndex(3) &&
                                            viewModel.isFullScreenEnabled,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: GestureDetector(
                                            onTap: viewModel
                                                .disableFullscreenVideoMode,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.close,
                                                  size: 48,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
