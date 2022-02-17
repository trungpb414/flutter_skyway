import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway/core/architecture/base_view.dart';
import 'package:flutter_skyway/presentation/group_chat/group_chat.viewmodel.dart';
import 'package:flutter_skyway/presentation/group_chat/widgets/circle_avatar.dart';
import 'package:flutter_skyway/presentation/group_chat/widgets/message_bubble.dart';
import 'package:intl/intl.dart';

class GroupChatView extends BaseView<GroupChatViewModel> {
  const GroupChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff517DA2),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Call ${viewModel.getCallTime()}',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              '3 members',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: CircleThumbAvatar(
                          avatar: viewModel.users[0].avatar ?? '',
                        ),
                        left: 50,
                      ),
                      Positioned(
                        child: CircleThumbAvatar(
                          avatar: viewModel.users[1].avatar ?? '',
                        ),
                        left: 25,
                      ),
                      Positioned(
                        child: CircleThumbAvatar(
                          avatar: viewModel.users[2].avatar ?? '',
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video chat',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff3A8CCF)),
                            ),
                            Text(
                              '3 participants',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff999999)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 70,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Back',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Observer(
                  builder: (context) => ListView.builder(
                    controller: viewModel.scrollController,
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: viewModel.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == viewModel.messages.length) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 14, bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xff728391).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                DateFormat('dd MMMM').format(DateTime.now()),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      }
                      return SentBubleMessage(
                        isSent: viewModel.messages[index].userSentId == 1,
                        hasAvatar: viewModel.hasAvatar(index),
                        messageModel: viewModel.messages[index],
                        userModel: viewModel.users[
                            (viewModel.messages[index].userSentId ?? 1) - 1],
                      );
                    },
                  ),
                ),
              ),
            ),
            TextFormField(
              maxLines: null,
              controller: viewModel.messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
                suffixIcon: IconButton(
                    onPressed: () {
                      viewModel.addMessage();
                    },
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.blueAccent,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
