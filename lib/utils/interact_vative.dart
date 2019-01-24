import 'package:flutter/services.dart';

class InteractNative {
  /* 通道名称，必须与原生注册的一致*/
  static const flutter_to_native = const MethodChannel(
      'com.bhm.flutter.flutternb.plugins/flutter_to_native');
  static const native_to_flutter = const EventChannel(
      'com.bhm.flutter.flutternb.plugins/native_to_flutter');

  /*
   * 方法名称，必须与flutter注册的一致
   */
  static final Map<String, String> methodNames = const {
    'register': 'register',
    'login': 'login',
    'logout': 'logout',
    'autoLogin': 'autoLogin',
    'connectionListener': 'connectionListener',
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
  * 调用原生的方法（带参）
  */
  static Stream<dynamic> dealNativeWithValue(){
    Stream<dynamic> stream = native_to_flutter.receiveBroadcastStream();
    return stream;
  }
}
