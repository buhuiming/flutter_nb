package com.bhm.flutter.flutternb.listeners;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.util.CallBackData;

import io.flutter.plugin.common.EventChannel;

/**
 * APP原生主动调用Flutter
 */
public class CallBackListener implements CallBack {

    private EventChannel.EventSink mSink;

    public CallBackListener(EventChannel.EventSink sink){
        mSink = sink;
    }

    @Override
    public Object call(Object o) {
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_STRING, "onDestroy"));//APP onDestroy时调用
        return null;
    }
}
