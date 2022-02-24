part of '../../video_chat.view.dart';

extension BuildVideoChat2Person on VideoChatView {
  Column buildVideoChat2People() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Visibility(
          visible: viewModel.indexFullScreenVideo == 1 ||
              viewModel.indexFullScreenVideo == 0,
          child: Expanded(
            flex: 1,
            child: GestureDetector(
              onDoubleTap: () {
                viewModel.setIndexFullScreenVideo(1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  height: 262,
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
                      viewModel.indexFullScreenVideo == 1
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.setIndexFullScreenVideo(0);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.close,
                                      size: 48, color: Colors.black),
                                ),
                              ),
                            )
                          : const SizedBox(),
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
          visible: viewModel.indexFullScreenVideo == 2 ||
              viewModel.indexFullScreenVideo == 0,
          child: Expanded(
            flex: 1,
            child: GestureDetector(
              onDoubleTap: () {
                viewModel.setIndexFullScreenVideo(2);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  height: 262,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _createRemoteView(viewModel.peers.keys.first),
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
                      viewModel.indexFullScreenVideo == 2
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.setIndexFullScreenVideo(0);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.close,
                                      size: 48, color: Colors.black),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
