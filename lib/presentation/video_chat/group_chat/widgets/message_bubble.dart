import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:flutter_skyway/presentation/video_chat/group_chat/message_model.dart';
import 'package:intl/intl.dart';

import 'circle_avatar.dart';

class SentBubleMessage extends StatelessWidget {
  const SentBubleMessage(
      {Key? key,
      required this.isSent,
      required this.userModel,
      required this.messageModel,
      required this.hasAvatar})
      : super(key: key);

  final bool isSent;
  final User userModel;
  final MessageModel messageModel;
  final bool hasAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          messageThumbAvatar(!isSent && hasAvatar),
          if (isSent)
            const SizedBox(
              width: 50,
            ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color:
                    isSent ? const Color(0xffEFFEDD) : const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 6, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(messageModel.content ?? '')
                        .defaultStyle()
                        .fontSize(16)
                        .fontWeight(FontWeight.w400),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      DateFormat('hh:mm a')
                          .format(messageModel.time ?? DateTime.now()),
                    ).defaultStyle().fontSize(12).color(isSent
                        ? const Color(0xff62AC55)
                        : const Color(0xffA1AAB3)),
                  ],
                ),
              ),
            ),
          ),
          if (!isSent)
            const SizedBox(
              width: 50,
            ),
          const SizedBox(
            width: 5,
          ),
          messageThumbAvatar(isSent && hasAvatar),
        ],
      ),
    );
  }

  Widget messageThumbAvatar(bool check) {
    if (check) {
      return CircleThumbAvatar(
        height: 25,
        width: 25,
        padding: 0,
        avatar: userModel.picture,
      );
    }
    return const SizedBox(
      width: 25,
    );
  }
}
