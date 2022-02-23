part of '../../video_chat.view.dart';

extension BuildVideoChat4People on VideoChatView {
  Widget _buildVideoChat4People() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2
                    .image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder
                    .image(width: 84, height: 84, fit: BoxFit.cover),
              ),
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2
                    .image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder
                    .image(width: 84, height: 84, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2
                    .image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder
                    .image(width: 84, height: 84, fit: BoxFit.cover),
              ),
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2
                    .image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder
                    .image(width: 84, height: 84, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemVideoChat(
      {required String name,
      required Image backgroundImage,
      required Image circleImage}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: backgroundImage,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFF71E079),
                    )),
                height: 84,
                width: 84,
                child: CircleAvatar(child: circleImage),
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
            // const Align(
            //   alignment: Alignment.center,
            //   child: CircularProgressIndicator(
            //     color: Colors.white,
            //     strokeWidth: 2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
