import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/base.dart';
import 'package:flutter_skyway/presentation/home/home.viewmodel.dart';

class HomeView extends BaseView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: const Text("START")
                .defaultStyle()
                .fontSize(40)
                .color(Colors.blue)),
      ),
    );
  }
}
