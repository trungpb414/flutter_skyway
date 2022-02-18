import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway/core/architecture/text.extension.dart';
import 'package:flutter_skyway/core/styles/text_style.dart';
import 'package:flutter_skyway/generated/assets.gen.dart';
import 'package:get/get.dart';

class SettingBottomSheet extends StatelessWidget {
  const SettingBottomSheet({
    Key? key,
    required this.onShareSelected,
    required this.onRecordSelected,
  }) : super(key: key);

  final VoidCallback onShareSelected;
  final VoidCallback onRecordSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffE1E4E9),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Setting',
            )
                .defaultStyle()
                .color(const Color(0xff222222))
                .fontSize(20)
                .fontWeight(FontWeight.w500),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Video and Audio',
            ).defaultStyle().color(const Color(0xff50A7EA)).fontSize(15),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                onShareSelected();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image(image: Assets.images.icShareScreen),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Share screen',
                  ).defaultStyle().color(const Color(0xff222222)),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                onRecordSelected();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image(image: Assets.images.icRecording),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Start recording")
                      .defaultStyle()
                      .color(const Color(0xFF222222))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
