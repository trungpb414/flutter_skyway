import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway/presentation/app/app.pages.dart';
import 'package:get/get.dart';

Future<void> application() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
