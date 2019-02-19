package com.bhm.flutter.flutternb.plugins;

import android.content.Intent;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.listeners.ConnectionListener;
import com.bhm.flutter.flutternb.listeners.ContactListener;
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
            put("register", "register");//注册
            put("login", "login");//登录
            put("logout", "logout");//退出登录
            put("autoLogin", "autoLogin");//自动登录
            put("backPress", "backPress");//物理返回键触发，主要是让应用返回桌面，而不是关闭应用
            put("addFriends", "addFriends");//添加好友
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
        }else if(methodNames.get("backPress").equals(methodCall.method)){//返回键返回桌面
            try {
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);// 注意
                intent.addCategory(Intent.CATEGORY_HOME);
                activity.startActivity(intent);
            }catch (Exception e){
                activity.finish();
            }
        }else if(methodNames.get("addFriends").equals(methodCall.method)){//添加好友
            EMClientUtils.addFriends(Objects.requireNonNull(methodCall.argument("toAddUsername")).toString(),
                    Objects.requireNonNull(methodCall.argument("reason")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public Boolean call(Object o) {
                            result.success(o);
                            return false;
                        }
                    });
        }
    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     * @param eventSink eventSink
     */
    static void onListen(FlutterActivity activity, Object o, EventChannel.EventSink eventSink){
        //注册一个监听连接状态的listener
        EMClient.getInstance().addConnectionListener(new ConnectionListener(activity, eventSink));
        //注册一个监听好友状态的listener
        EMClient.getInstance().contactManager().setContactListener(new ContactListener(eventSink));
    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     */
    static void onCancel(FlutterActivity activity, Object o) {

    }
}
