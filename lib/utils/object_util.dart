import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';

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
  static Color getThemeColor({String color: "white"}) {
    return themeColorMap[color];
  }

  /*
  *  获取app的主题颜色
  */
  static Color getThemeSwatchColor({String color: "blue"}) {
    return themeSwatchColorMap[color];
  }

  /*
  * 退出登录调用
  */
  static void doExit(BuildContext context) {
    NotificationUtil.build().cancelAll();
    MessageDataBase.get().close();
    InteractNative.closeStream();
    SPUtil.putBool(Constants.KEY_LOGIN, false);
    Navigator.of(context).pushReplacementNamed('/LoginPage');
  }
}
