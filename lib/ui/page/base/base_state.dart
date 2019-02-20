import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
*  State基类，监听原生的回调，更新页面
*/
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  StreamSubscription _subscription = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addConnectionListener(); //添加监听
  }

  _addConnectionListener() {
    if (null == _subscription) {
      _subscription = InteractNative.dealNativeWithValue()
          .listen(onEvent, onError: onError);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void onEvent(Object event) {
    if ('onConnected' == event) {
      //已连接
    } else if ('user_removed' == event) {
      //显示帐号已经被移除
      DialogUtil.buildToast('flutter帐号已经被移除');
    } else if ('user_login_another_device' == event) {
      //显示帐号在其他设备登录
      DialogUtil.buildToast('flutter帐号在其他设备登录');
      SPUtil.putBool(Constants.KEY_LOGIN, false);
      Navigator.of(context).pushReplacementNamed('/LoginPage');
    } else if ('disconnected_to_service' == event) {
      //连接不到聊天服务器
      DialogUtil.buildToast('连接不到聊天服务器');
    } else if ('no_net' == event) {
      //当前网络不可用，请检查网络设置
      DialogUtil.buildToast('当前网络不可用，请检查网络设置');
    }
  }

  void onError(Object error) {
    DialogUtil.buildToast(error.toString());
  }
}
