package com.bhm.flutter.flutternb.listeners;

import com.google.gson.Gson;
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
        mSink.success(new Gson().toJson(new ContactEntity("message", "onContactAdded", username)));
    }

    @Override
    public void onContactDeleted(String username) {
        //被删除时回调此方法
        mSink.success(new Gson().toJson(new ContactEntity("message", "onContactDeleted", username)));
    }

    @Override
    public void onContactInvited(String username, String reason) {
        //收到好友邀请
        mSink.success(new Gson().toJson(new ContactEntity("message", "onContactInvited", username, reason)));
    }

    @Override
    public void onFriendRequestAccepted(String username) {
        //好友请求被同意
        mSink.success(new Gson().toJson(new ContactEntity("message", "onFriendRequestAccepted", username)));
    }

    @Override
    public void onFriendRequestDeclined(String username) {
        //好友请求被拒绝
        mSink.success(new Gson().toJson(new ContactEntity("message", "onFriendRequestDeclined", username)));
    }

    class ContactEntity{
        private String type;
        private String method;
        private String username;
        private String reason;

        public ContactEntity(String type, String method, String username, String reason){
            this.type = type;
            this.method = method;
            this.username = username;
            this.reason = reason;
        }
        public ContactEntity(String type, String method, String username){
            this.type = type;
            this.method = method;
            this.username = username;
        }
    }
}
