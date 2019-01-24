package com.bhm.flutter.flutternb.plugins;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * flutter与原生双向交互的插件
 */
public class FlutterPlugins implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler{

    private FlutterActivity activity;

    private FlutterPlugins(FlutterActivity activity) {
        this.activity = activity;
    }

    public static void registerWith(FlutterActivity activity) {
        FlutterPlugins instance = new FlutterPlugins(activity);
        //flutter调用原生
        MethodChannel channel = new MethodChannel(activity.registrarFor(DealMethodCall.channels_flutter_to_native)
                .messenger(), DealMethodCall.channels_flutter_to_native);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);

        //原生调用flutter
        EventChannel eventChannel = new EventChannel(activity.registrarFor(DealMethodCall.channels_native_to_flutter)
                .messenger(), DealMethodCall.channels_native_to_flutter);
        eventChannel.setStreamHandler(instance);
    }
    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        DealMethodCall.onMethodCall(activity, methodCall, result);
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        DealMethodCall.onListen(activity, o, eventSink);
    }

    @Override
    public void onCancel(Object o) {
        DealMethodCall.onCancel(activity, o);
    }
}
