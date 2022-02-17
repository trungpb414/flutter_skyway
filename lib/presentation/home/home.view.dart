import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/presentation/home/home.viewmodel.dart';

import '../common.widgets/widgets.dart';

class HomeView extends BaseView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Start Video Call")
                  .defaultStyle()
                  .fontSize(20)
                  .fontWeight(FontWeight.w500)
                  .color(
                    const Color(0xFF222222),
                  ),
              const SizedBox(
                height: 16,
              ),
              const Text("Start video call in mode:")
                  .defaultStyle()
                  .fontWeight(FontWeight.w400)
                  .fontSize(15)
                  .color(
                    const Color(0xFF222222),
                  ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 39,
                            child: NormalButton(
                              backgroundColor: Colors.white,
                              onPressed: () =>
                                  viewModel.setCallModeType(CallModeType.sfu),
                              child: const Text("SFU")
                                  .defaultStyle()
                                  .fontSize(13)
                                  .color(Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 39,
                            child: NormalButton(
                              backgroundColor: const Color(0xFFE14D4D),
                              child: const Text("MESH")
                                  .defaultStyle()
                                  .fontSize(13)
                                  .color(Colors.white),
                              onPressed: () =>
                                  viewModel.setCallModeType(CallModeType.mesh),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    SizedBox(
                      // width: 312,
                      height: 40,
                      child: Form(
                        key: viewModel.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          initialValue: viewModel.roomName,
                          onChanged: (value) => viewModel.roomName = value,
                          validator: viewModel.roomNameValidator,
                          decoration: const InputDecoration(
                            hintText: "Room Name",
                            hintStyle: TextStyle(
                                fontFamily: FontFamily.roboto,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 39,
                      child: NormalButton(
                        child: const Text("HOST")
                            .defaultStyle()
                            .fontWeight(FontWeight.w500)
                            .color(Colors.white),
                        onPressed: viewModel.toHostVideoChat,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 39,
                      child: NormalButton(
                        onPressed: viewModel.toJoinVideoChat,
                        child: const Text("JOIN")
                            .defaultStyle()
                            .fontWeight(FontWeight.w500)
                            .color(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
