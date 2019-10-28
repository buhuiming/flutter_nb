package com.bhm.flutter.flutternb.listeners;

import com.alibaba.fastjson.JSON;
import com.bhm.flutter.flutternb.util.CallBackData;
import com.bhm.flutter.flutternb.util.MessageEntity;
import com.bhm.flutter.flutternb.util.Utils;
import com.hyphenate.EMContactListener;

import io.flutter.plugin.common.EventChannel;

public class ContactListener implements EMContactListener {

    private EventChannel.EventSink mSink;

    public ContactListener(EventChannel.EventSink sink){
        mSink = sink;
    }

    @Override
    public void onContactAdded(String username) {
        //增加联系人时回调此方法
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON,
                JSON.toJSONString(new MessageEntity("chat", "onContactAdded", username))));
    }

    @Override
    public void onContactDeleted(String username) {
        //被删除时回调此方法
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON,
                JSON.toJSONString(new MessageEntity("chat", "onContactDeleted", username))));
    }

    @Override
    public void onContactInvited(String username, String reason) {
        //收到好友邀请
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON,
                JSON.toJSONString(new MessageEntity("system", "onContactInvited", username, reason))));
    }

    @Override
    public void onFriendRequestAccepted(String username) {
        //好友请求被同意
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON,
                JSON.toJSONString(new MessageEntity("system", "onFriendRequestAccepted", username))));
    }

    @Override
    public void onFriendRequestDeclined(String username) {
        //好友请求被拒绝
        Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON,
                JSON.toJSONString(new MessageEntity("system", "onFriendRequestDeclined", username))));
    }
}
