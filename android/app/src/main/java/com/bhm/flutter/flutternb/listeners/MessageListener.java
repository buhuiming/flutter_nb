package com.bhm.flutter.flutternb.listeners;

import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.bhm.flutter.flutternb.util.CallBackData;
import com.bhm.flutter.flutternb.util.MessageEntity;
import com.bhm.flutter.flutternb.util.Utils;
import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;

import java.util.List;

import io.flutter.plugin.common.EventChannel;

public class MessageListener implements EMMessageListener {

    private EventChannel.EventSink mSink;
    private static final MessageListener LISTENER = new MessageListener();
    public static MessageListener get(){
        return LISTENER;
    }

    private MessageListener(){}

    public MessageListener register(EventChannel.EventSink sink){
        mSink = sink;
        return LISTENER;
    }

    public void unRegister(){
        EMClient.getInstance().chatManager().removeMessageListener(LISTENER);
    }

    @Override
    public void onMessageReceived(List<EMMessage> messages) {
        //收到消息
        for(EMMessage message : messages) {
            //把消息主体body放在note字段
            MessageEntity entity = new MessageEntity(Utils.getChatType(message),"onMessageReceived",
                    Utils.getType(message.getType()), message.getFrom(), String.valueOf(message.getMsgTime()),
                    JSON.toJSONString(message.getBody()));
            Utils.doOnMainThread(mSink, CallBackData.setData(CallBackData.TYPE_OF_JSON, JSON.toJSONString(entity)));
            Log.i("MessageListener", "收到消息----> " + message.toString());
        }
    }

    @Override
    public void onCmdMessageReceived(List<EMMessage> messages) {
        //收到透传消息
        for(EMMessage message : messages) {
            //把消息主体body放在note字段

            Log.i("MessageListener", "收到透传消息----> " + message.toString());
        }
    }

    @Override
    public void onMessageRead(List<EMMessage> messages) {
        //收到已读回执
        for(EMMessage message : messages) {
            //把消息主体body放在note字段

            Log.i("MessageListener", "收到已读回执----> " + message.toString());
        }
    }

    @Override
    public void onMessageDelivered(List<EMMessage> messages) {
        //收到已送达回执
        for(EMMessage message : messages) {

            Log.i("MessageListener", "收到已送达回执----> " + message.toString());
        }
    }

    @Override
    public void onMessageChanged(EMMessage message, Object change) {
        //消息状态变动

        Log.i("MessageListener", "消息状态变动----> " + message.toString());
    }
}
