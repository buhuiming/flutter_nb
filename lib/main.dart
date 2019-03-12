import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/main/main_page.dart';
import 'package:flutter_nb/ui/page/splash_page.dart';
import 'package:flutter_nb/utils/data_proxy.dart';
import 'package:flutter_nb/utils/device_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeviceUtil.setBarStatus(true);
    DataProxy.build().connect(context);//启动APP时，就建立与原生的交互
    return MaterialApp(home: new SplashPage(), routes: {
      '/MainPage': (ctx) => MainPage(),
    });
  }
}
