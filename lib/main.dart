import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_skyway/presentation/app/app.main.dart';
import 'package:mobx/mobx.dart';

void initMobXSpy() {
  mainContext.config = mainContext.config.clone(
    isSpyEnabled: true,
  );
  mainContext.spy((event) {
    /// Only log start
    if (event.isStart) {
      /// action, observable, reaction. Skip reaction log
      if(event.type != "reaction") {
        developer.log(event.toString(), name: 'MOBX SPY');
      }
    }
  },);
}

Future<void> main() async {
  /// Init to load native code
  WidgetsFlutterBinding.ensureInitialized();

  /// Spying inside MobX
  initMobXSpy();

  /// Run app
  await application();
}
