import 'package:flutter/material.dart';
import 'package:flutter_skyway/generated/assets.gen.dart';
import 'package:flutter_skyway/presentation/app/app.viewmodel.dart';
import 'package:flutter_skyway/core/base.dart';

class AppView extends BaseView<AppViewModel> {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(child: Assets.images.vietis.image()),
        ),
      ),
    );
  }
}
