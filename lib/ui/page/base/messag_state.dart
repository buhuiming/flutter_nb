import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/base/base_state.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
* 消息类State基类，监听原生的回调，更新页面
*/
abstract class MessageState<T extends StatefulWidget> extends BaseState<T> {
  void onEvent(Object event) {
    super.onEvent(event);
  }

  void onError(Object error) {}
}
