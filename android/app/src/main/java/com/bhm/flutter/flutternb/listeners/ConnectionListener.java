package com.bhm.flutter.flutternb.listeners;

import com.bhm.flutter.flutternb.util.CallBackData;
import com.bhm.flutter.flutternb.util.Utils;
import com.hyphenate.EMConnectionListener;
import com.hyphenate.EMError;
import com.hyphenate.util.NetUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;

/**
 * 网络连接状态监听
 */
public class ConnectionListener implements EMConnectionListener {

    private FlutterActivity mActivity;
    private EventChannel.EventSink mSink;

    public ConnectionListener(FlutterActivity activity, EventChannel.EventSink sink){
        mActivity = activity;
        mSink = sink;
    }

    @Override
    public void onConnected() {
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_STRING, "onConnected"));
    }
    @Override
    public void onDisconnected(final int error) {
        if(error == EMError.USER_REMOVED){
            // 显示帐号已经被移除
            Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_STRING, "user_removed"));
        }else if (error == EMError.USER_LOGIN_ANOTHER_DEVICE) {
            // 显示帐号在其他设备登录
            Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_STRING, "user_login_another_device"));
        } else {
            if (NetUtils.hasNetwork(mActivity)) {
                //连接不到聊天服务器
                Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_STRING, "disconnected_to_service"));
            } else {
                //当前网络不可用，请检查网络设置
                Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_STRING, "no_net"));
            }
        }
    }
}
