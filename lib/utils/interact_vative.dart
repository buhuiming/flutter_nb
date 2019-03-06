import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:rxdart/rxdart.dart';

class InteractNative {
  /* 通道名称，必须与原生注册的一致*/
  static const flutter_to_native = const MethodChannel(
      'com.bhm.flutter.flutternb.plugins/flutter_to_native');
  static const native_to_flutter =
      const EventChannel('com.bhm.flutter.flutternb.plugins/native_to_flutter');

  static StreamSubscription streamSubscription;

  static BehaviorSubject<int> _appEvent = BehaviorSubject<int>(); //APP内部通信对象
  static BehaviorSubject<MessageEntity> _messageEvent =
      BehaviorSubject<MessageEntity>(); //APP内部通信对象

  static const int RESET_THEME_COLOR = 1;
  static const String SYSTEM_MESSAGE_HAS_READ = 'system_message_has_read';
  static const String SYSTEM_MESSAGE_DELETE_ALL = 'system_message_delete_all';
  static const String SYSTEM_MESSAGE_DELETE = 'system_message_delete';
  /*
   * 方法名称，必须与flutter注册的一致
   */
  static final Map<String, String> methodNames = const {
    'register': 'register', //注册
    'login': 'login', //登录
    'logout': 'logout', //退出登录
    'autoLogin': 'autoLogin', //自动登录
    'backPress': 'backPress', //物理返回键触发，主要是让应用返回桌面，而不是关闭应用
    'addFriends': 'addFriends', //添加好友
    'refusedFriends': 'refusedFriends', //拒绝好友添加邀请
  };

  /*
  * 调用原生的方法（带参）
  */
  static Future<dynamic> goNativeWithValue(String methodName,
      [Map<String, String> map]) async {
    if (null == map) {
      dynamic future = await flutter_to_native.invokeMethod(methodName);
      return future;
    } else {
      dynamic future = await flutter_to_native.invokeMethod(methodName, map);
      return future;
    }
  }

  /*
  * 原生回调的方法（带参）
  */
  static StreamSubscription dealNativeWithValue(Function event,
      {Function onError, void onDone(), bool cancelOnError}) {
    streamSubscription = native_to_flutter
        .receiveBroadcastStream()
        .listen(event, onError: onError);
    return streamSubscription;
  }

  /*
  * 自定义通信
  */
  static BehaviorSubject<int> initAppEvent() {
    if (null == _appEvent) {
      _appEvent = BehaviorSubject<int>();
    }
    return _appEvent;
  }

  /*
  * 自定义通信
  */
  static BehaviorSubject<MessageEntity> initMessageEvent() {
    if (null == _messageEvent || _messageEvent.isClosed) {
      _messageEvent = BehaviorSubject<MessageEntity>();
    }
    return _messageEvent;
  }

  /*发送*/
  static Sink<MessageEntity> getMessageEventSink() {
    initMessageEvent();
    return _messageEvent.sink;
  }

  /*发送*/
  static Sink<int> getAppEventSink() {
    initAppEvent();
    return _appEvent.sink;
  }

  /*接收*/
  static Stream<int> getAppEventStream() {
    initAppEvent();
    return _appEvent.stream;
  }

  /*接收*/
  static Stream<MessageEntity> getMessageEventStream() {
    initMessageEvent();
    return _messageEvent.stream;
  }

  /*
  *  退出登录时，需要关闭
  */
  static void closeStream() {
    if (null != _appEvent) {
      _appEvent.close();
    }
    if (null != _messageEvent) {
      _messageEvent.close();
    }
  }
}
