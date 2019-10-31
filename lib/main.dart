import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/main/main_page.dart';
import 'package:flutter_nb/ui/page/splash_page.dart';
import 'package:flutter_nb/utils/data_proxy.dart';
import 'package:flutter_nb/utils/device_util.dart';

//void main() => runApp(MyApp());

void collectLog(String line) {
  //收集日志
}
void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };
  runZoned(
    () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line); // 收集日志
      },
    ),
    onError: (Object obj, StackTrace stack) {
      var details = makeDetails(obj, stack);
      reportErrorAndLog(details);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeviceUtil.setBarStatus(true);
    DataProxy.build().connect(context); //启动APP时，就建立与原生的交互
    return MaterialApp(home: new SplashPage(), routes: {
      '/MainPage': (ctx) => MainPage(),
    });
  }
}
