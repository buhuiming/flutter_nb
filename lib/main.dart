import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/page/login_page.dart';
import 'package:flutter_nb/ui/page/main_page.dart';
import 'package:flutter_nb/ui/page/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: ColorT.app_main,
            accentColor: ColorT.app_main,
            indicatorColor: Colors.white),
        home: new SplashPage(),
        routes: {
          '/LoginPage': (ctx) => LoginPage(),
        });
  }
}
