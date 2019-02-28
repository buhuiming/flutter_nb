import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/login_page.dart';
import 'package:flutter_nb/ui/page/main/main_page.dart';
import 'package:flutter_nb/ui/page/splash_page.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/object_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeviceUtil.setBarStatus(true);
    return MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            accentColor: ObjectUtil.getThemeSwatchColor(),
            indicatorColor: ObjectUtil.getThemeColor()),
        home: new SplashPage(),
        routes: {
          '/LoginPage': (ctx) => LoginPage(),
          '/MainPage': (ctx) => MainPage(),
        });
  }
}
