package com.bhm.flutter.flutternb.listeners;

import com.bhm.flutter.flutternb.util.CallBackData;
import com.google.gson.Gson;
import com.hyphenate.EMContactListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class ContactListener implements EMContactListener {

    private EventChannel.EventSink mSink;
    private Map res = new HashMap();

    public ContactListener(EventChannel.EventSink sink){
        mSink = sink;
    }

    @Override
    public void onContactAdded(String username) {
        //增加联系人时回调此方法
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_JSON, new Gson().
                toJson(new ContactEntity("system", "onContactAdded", username))));
    }

    @Override
    public void onContactDeleted(String username) {
        //被删除时回调此方法
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_JSON, new Gson().
                toJson(new ContactEntity("system", "onContactDeleted", username))));
    }

    @Override
    public void onContactInvited(String username, String reason) {
        //收到好友邀请
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_JSON, new Gson().
                toJson(new ContactEntity("system", "onContactInvited", username, reason))));
    }

    @Override
    public void onFriendRequestAccepted(String username) {
        //好友请求被同意
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_JSON, new Gson().
                toJson(new ContactEntity("system", "onFriendRequestAccepted", username))));
    }

    @Override
    public void onFriendRequestDeclined(String username) {
        //好友请求被拒绝
        mSink.success(CallBackData.setData(CallBackData.TYPE_OF_JSON, new Gson().
                toJson(new ContactEntity("system", "onFriendRequestDeclined", username))));
    }

    class ContactEntity{
        private String type;
        private String content_type;
        private String sender_account;
        private String note;

        public ContactEntity(String type, String method, String username, String reason){
            this.type = type;
            this.content_type = method;
            this.sender_account = username;
            this.note = reason;
        }
        public ContactEntity(String type, String method, String username){
            this.type = type;
            this.content_type = method;
            this.sender_account = username;
        }
    }
}
