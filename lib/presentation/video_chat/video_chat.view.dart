import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/presentation/common.widgets/image_button.dart';
import 'package:flutter_skyway/presentation/video_chat/video_chat.viewmodel.dart';
import 'package:flutter_skyway/presentation/video_chat/widgets/skyway_canvas_view.dart';

part 'widgets/video_view.dart';

class VideoChatView extends BaseView<VideoChatViewModel> {
  const VideoChatView({Key? key}) : super(key: key);

  final ValueKey _localVideoKey = const ValueKey('localVideo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14161C),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          viewModel.goToChat();
                        },
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Assets.images.icCircleBtnChat.svg(height: 44, width: 44),
                              ),
                              Positioned(
                                top: -4,
                                left: 27,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  height: 24,
                                  width: 24,
                                  child: const Text(
                                    "1",
                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontSize: 13),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          viewModel.showSetting(context);
                        },
                        child: Assets.images.icCircleBtnMore.svg(height: 44, width: 44),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Observer(
                  builder: (_) => Expanded(
                    child: _buildVideoChat(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageButton(
                        child: Assets.images.icCircleBtnRotate.svg(
                          height: 58,
                          width: 58,
                        ),
                        onPressed: viewModel.rotateCameraTrigger,
                      ),
                      ImageButton(
                        onPressed: viewModel.toggleCameraTrigger,
                        child: Assets.images.icCircleBtnCamera.svg(
                          height: 58,
                          width: 58,
                        ),
                      ),
                      ImageButton(
                        onPressed: viewModel.toggleMicTrigger,
                        child: Assets.images.icCircleBtnMic.svg(
                          height: 58,
                          width: 58,
                        ),
                      ),
                      ImageButton(
                        onPressed: () {
                          viewModel.declineTrigger(context);
                        },
                        child: Assets.images.icCircleBtnDecline.svg(
                          height: 58,
                          width: 58,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 86),
                child: _buildNotification(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoChat() {
    return Observer(
      builder: (context) {
        if (viewModel.isConnected) {
          switch (viewModel.totalRemotePeer) {
            case 1:
              return buildVideoChat2People();
            case 0:
              return buildVideoChat1Person();
            default:
              return buildVideoChat1Person();
          }
        }
        return Container();
      },
    );
  }

  Center buildVideoChat1Person() {
    return Center(
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
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        alignment: Alignment.center,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFD4D4D4).withOpacity(0.2),
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
                            Assets.images.icLock.svg(height: 16, width: 16)
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
                  child: const Text("You").defaultStyle().fontSize(14).fontWeight(FontWeight.w500).color(Colors.white),
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
                    child: Assets.images.icMask.svg(width: 20, height: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildVideoChat2People() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
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
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            alignment: Alignment.center,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFD4D4D4).withOpacity(0.2),
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
                                Assets.images.icLock.svg(height: 16, width: 16)
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
                      child:
                          const Text("You").defaultStyle().fontSize(14).fontWeight(FontWeight.w500).color(Colors.white),
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
                        child: Assets.images.icMask.svg(width: 20, height: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          flex: 1,
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
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            alignment: Alignment.center,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFD4D4D4).withOpacity(0.2),
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
                                Assets.images.icLock.svg(height: 16, width: 16)
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
                      child:
                          const Text("You").defaultStyle().fontSize(14).fontWeight(FontWeight.w500).color(Colors.white),
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
                        child: Assets.images.icMask.svg(width: 20, height: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVideoChat3People() {
    return Column(
      children: [
        Expanded(
          flex: 1,
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
                    child: Assets.images.imgPlaceHolder1.image(fit: BoxFit.fill),
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
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            alignment: Alignment.center,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFD4D4D4).withOpacity(0.2),
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
                                Assets.images.icLock.svg(height: 16, width: 16)
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
                      child:
                          const Text("You").defaultStyle().fontSize(14).fontWeight(FontWeight.w500).color(Colors.white),
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
                        child: Assets.images.icMask.svg(width: 20, height: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 284,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                  borderRadius: BorderRadius.circular(12),
                                  child: Assets.images.imgPlaceHolder2.image(fit: BoxFit.fill),
                                ),
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
                                  child: Assets.images.icDots.svg(height: 24, width: 24),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text("Anya")
                                      .defaultStyle()
                                      .fontSize(14)
                                      .fontWeight(FontWeight.w500)
                                      .color(Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Assets.images.imgPlaceHolder3.image(fit: BoxFit.fill)),
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
                                  child: Assets.images.icDots.svg(height: 24, width: 24),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Danil")
                                          .defaultStyle()
                                          .fontSize(14)
                                          .fontWeight(FontWeight.w500)
                                          .color(Colors.white),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Assets.images.icMicUnmute.svg(height: 16, width: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ],
    );
  }

  Widget _buildNotification() {
    return Observer(
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: viewModel.notifications.length,
        itemBuilder: (_, index) {
          return buildNotificationItem(viewModel.notifications[index].circleImage, viewModel.notifications[index].name);
        },
      ),
    );
  }

  Widget buildNotificationItem(Widget circleWidget, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF272F38).withOpacity(0.92),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 25,
            width: 25,
            child: CircleAvatar(
              child: circleWidget,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          RichText(
            text: TextSpan(
                text: name,
                style: const TextStyle(
                  fontFamily: FontFamily.roboto,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                children: const [
                  TextSpan(
                    text: " joined the voice chat.",
                    style: TextStyle(
                      fontFamily: FontFamily.roboto,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoChat4People() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2.image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder.image(width: 84, height: 84, fit: BoxFit.cover),
              ),
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2.image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder.image(width: 84, height: 84, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2.image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder.image(width: 84, height: 84, fit: BoxFit.cover),
              ),
              _buildItemVideoChat(
                name: "You",
                backgroundImage: Assets.images.imgAvatarPlaceHolder2.image(fit: BoxFit.cover),
                circleImage: Assets.images.imgCircleAvartarPlaceHolder.image(width: 84, height: 84, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemVideoChat({required String name, required Image backgroundImage, required Image circleImage}) {
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
