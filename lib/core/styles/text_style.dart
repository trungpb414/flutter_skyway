import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/architecture/text_extension.dart';

extension BaseTextExtension on Text {
  Text defaultStyle() {
    return fontSize(14);
  }
}