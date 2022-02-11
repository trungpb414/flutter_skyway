import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseView<T> extends StatelessWidget {
  const BaseView({Key? key}) : super(key: key);

  final String? tag = null;

  T get viewModel => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}
