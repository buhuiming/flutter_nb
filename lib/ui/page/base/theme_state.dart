/*
*  State基类，更新页面用
*/
import 'package:flutter/material.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

abstract class ThemeState<T extends StatefulWidget> extends State<T> {
  Color primaryColor;
  MaterialColor primarySwatch;
  Color themeLightColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    _addListener(); //添加监听
  }

  init() {
    primaryColor = ObjectUtil.getThemeColor();
    primarySwatch = ObjectUtil.getThemeSwatchColor();
    themeLightColor = ObjectUtil.getThemeLightColor();
  }

  _addListener() {
    InteractNative.initAppEvent();
    InteractNative.getAppEventStream().listen((value) {
      notify(value);
    });
  }

  @protected
  void notify(Object o);

}
