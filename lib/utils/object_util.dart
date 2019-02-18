import 'dart:ui';

import 'package:flutter_nb/resource/colors.dart';

class ObjectUtil {
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  /*
  *  获取app的AppBar、ToolBar颜色
  */
  static Color getThemeColor({String color: "white"}){
    return themeColorMap[color];
  }

  /*
  *  获取app的主题颜色
  */
  static Color getThemeSwatchColor({String color: "blue"}){
    return themeSwatchColorMap[color];
  }
}
