package com.bhm.flutter.flutternb.listeners;

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
        mSink.success("onConnected");
    }
    @Override
    public void onDisconnected(final int error) {
        if(error == EMError.USER_REMOVED){
            // 显示帐号已经被移除
            mSink.success("user_removed");
        }else if (error == EMError.USER_LOGIN_ANOTHER_DEVICE) {
            // 显示帐号在其他设备登录
            mSink.success("user_login_another_device");
        } else {
            if (NetUtils.hasNetwork(mActivity)) {
                //连接不到聊天服务器
                mSink.success("disconnected_to_service");
            } else {
                //当前网络不可用，请检查网络设置
                mSink.success("no_net");
            }
        }
    }
}
