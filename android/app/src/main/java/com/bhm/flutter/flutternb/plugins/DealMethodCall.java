package com.bhm.flutter.flutternb.plugins;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.util.EMClientUtils;
import com.hyphenate.chat.EMClient;

import java.util.HashMap;
import java.util.Objects;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class DealMethodCall {

    /**
     * 通道名称，必须与flutter注册的一致
     */
    static final String channels_flutter_to_native = "com.bhm.flutter.flutternb.plugins/flutter_to_native";
    static final String channels_native_to_flutter = "com.bhm.flutter.flutternb.plugins/native_to_flutter";
    /**
     * 方法名称，必须与flutter注册的一致
     */
    private static final HashMap<String, String> methodNames = new HashMap<String, String>(){
        {
            put("register", "register");
            put("login", "login");
            put("logout", "logout");
            put("autoLogin", "autoLogin");
            put("connectionListener", "connectionListener");
        }
    };

    /** flutter调用原生方法的回调
     * @param activity activity
     * @param methodCall methodCall
     * @param result result
     */
    static void onMethodCall(FlutterActivity activity, MethodCall methodCall, final MethodChannel.Result result){
        if(methodNames.get("register").equals(methodCall.method)){//注册账号
            EMClientUtils.register(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    Objects.requireNonNull(methodCall.argument("password")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public Boolean call(Object o) {
                            result.success(o);
                            return false;
                        }
                    });
        }else if(methodNames.get("login").equals(methodCall.method)){//登录
            EMClientUtils.login(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    Objects.requireNonNull(methodCall.argument("password")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public Boolean call(Object o) {
                            result.success(o);
                            return false;
                        }
                    });
        }else if(methodNames.get("logout").equals(methodCall.method)){//退出登录
            EMClientUtils.logout(new CallBack<Boolean>() {
                @Override
                public Boolean call(Object o) {
                    result.success(o);
                    return false;
                }
            });
        }else if(methodNames.get("autoLogin").equals(methodCall.method)){//自动登录
            EMClient.getInstance().groupManager().loadAllGroups();
            EMClient.getInstance().chatManager().loadAllConversations();
        }else if(methodNames.get("connectionListener").equals(methodCall.method)){//添加IM状态监听
            //注册一个监听连接状态的listener
            EMClient.getInstance().addConnectionListener(new ConnectionListener(activity, result));
        }
    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     * @param eventSink eventSink
     */
    static void onListen(FlutterActivity activity, Object o, EventChannel.EventSink eventSink){

    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     */
    static void onCancel(FlutterActivity activity, Object o) {

    }
}
