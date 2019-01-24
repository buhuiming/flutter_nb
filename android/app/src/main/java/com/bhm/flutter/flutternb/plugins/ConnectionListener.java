package com.bhm.flutter.flutternb.plugins;

import com.hyphenate.EMConnectionListener;
import com.hyphenate.EMError;
import com.hyphenate.util.NetUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class ConnectionListener implements EMConnectionListener {

    private FlutterActivity mActivity;
    private MethodChannel.Result mResult;

    ConnectionListener(FlutterActivity activity, MethodChannel.Result result){
        mActivity = activity;
        mResult = result;
    }

    @Override
    public void onConnected() {
        mResult.success("onConnected");
    }
    @Override
    public void onDisconnected(final int error) {
        if(error == EMError.USER_REMOVED){
            // 显示帐号已经被移除
            mResult.success("user_removed");
        }else if (error == EMError.USER_LOGIN_ANOTHER_DEVICE) {
            // 显示帐号在其他设备登录
            mResult.success("user_login_another_device");
        } else {
            if (NetUtils.hasNetwork(mActivity)) {
                //连接不到聊天服务器
                mResult.success("disconnected_to_service");
            }
            else {
                //当前网络不可用，请检查网络设置
                mResult.success("no_net");
            }
        }
    }
}
