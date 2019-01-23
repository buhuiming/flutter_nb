package com.bhm.flutter.flutternb.plugins;

import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

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
    private static final String[] methodNames = {"register"};

    /** flutter调用原生方法的回调
     * @param activity activity
     * @param methodCall methodCall
     * @param result result
     */
    static void onMethodCall(FlutterActivity activity, MethodCall methodCall, final MethodChannel.Result result){
        if(methodNames[0].equals(methodCall.method)){//注册账号
            Log.e("register: username--> ", Objects.requireNonNull(methodCall.argument("username")).toString());
            Log.e("register: password--> ", Objects.requireNonNull(methodCall.argument("password")).toString());
            Toast.makeText(activity, "android received： username is " + Objects.requireNonNull(methodCall.
                    argument("username")).toString() + ". and password is " +
                    Objects.requireNonNull(methodCall.argument("password")).toString(),
                    Toast.LENGTH_LONG).show();
            new Handler().postDelayed(new Runnable() {

                @Override
                public void run() {
                    result.success("success");
                }
            }, 2500);
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
