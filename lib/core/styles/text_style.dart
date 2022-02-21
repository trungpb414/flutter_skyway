import 'package:flutter/material.dart';
import 'package:flutter_skyway/core/architecture/text.extension.dart';

import '../../generated/fonts.gen.dart';

extension BaseTextExtension on Text {
  Text defaultStyle() {
    return fontSize(14)
        .fontFamily(FontFamily.roboto)
        .fontStyle(FontStyle.normal);
  }
}
