/*
*  State基类，更新页面用
*/
import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/base/base_state.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

abstract class ThemeState<T extends StatefulWidget> extends BaseState<T> {
  Color primaryColor;
  MaterialColor primarySwatch;
  Color themeLightColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _addListener(); //添加监听
  }

  _init() {
    primaryColor = ObjectUtil.getThemeColor();
    primarySwatch = ObjectUtil.getThemeSwatchColor();
    themeLightColor = ObjectUtil.getThemeLightColor();
  }

  _addListener() {
    InteractNative.initAppEvent();
    InteractNative.getAppEventStream().listen((value) {
      setState(() {
        if (value == InteractNative.RESET_THEME_COLOR) {
          _init();
        }
      });
    });
  }
}
