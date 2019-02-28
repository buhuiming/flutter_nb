import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
*  State基类，监听原生的回调，更新页面
*/
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addConnectionListener(); //添加监听
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (SPUtil.getBool(Constants.KEY_LOGIN) != true) {
      ObjectUtil.doExit(context);
    }
  }

  _addConnectionListener() {
    InteractNative.dealNativeWithValue(onEvent, onError: onError);
  }

  void onEvent(Object event) {
    if (event == null || !(event is Map)) {
      return;
    }
    Map res = event;
    if (res.containsKey('string')) {
      if (res.containsValue('onConnected')) {
        //已连接
      } else if (res.containsValue('user_removed')) {
        //显示帐号已经被移除
        DialogUtil.buildToast('flutter帐号已经被移除');
        ObjectUtil.doExit(context);
      } else if (res.containsValue('user_login_another_device')) {
        //显示帐号在其他设备登录
        DialogUtil.buildToast('flutter帐号在其他设备登录');
        ObjectUtil.doExit(context);
      } else if (res.containsValue('disconnected_to_service')) {
        //连接不到聊天服务器
        DialogUtil.buildToast('连接不到聊天服务器');
      } else if (res.containsValue('no_net')) {
        //当前网络不可用，请检查网络设置
        DialogUtil.buildToast('当前网络不可用，请检查网络设置');
      }
    }
  }

  void onError(Object error) {
    DialogUtil.buildToast(error.toString());
  }
}
