package com.bhm.flutter.flutternb.plugins;

import android.content.Intent;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.listeners.CallBackListener;
import com.bhm.flutter.flutternb.listeners.ConnectionListener;
import com.bhm.flutter.flutternb.listeners.ContactListener;
import com.bhm.flutter.flutternb.listeners.MessageListener;
import com.bhm.flutter.flutternb.ui.VideoRecordActivity;
import com.bhm.flutter.flutternb.util.EMClientUtils;
import com.bhm.flutter.flutternb.util.Utils;
import com.bhm.sdk.onresult.ActivityResult;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;

import java.util.HashMap;
import java.util.Map;
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
    private static final HashMap<String, String> methodNames = new HashMap<String, String>(){
        {
            put("register", "register");//注册
            put("login", "login");//登录
            put("logout", "logout");//退出登录
            put("autoLogin", "autoLogin");//自动登录
            put("backPress", "backPress");//物理返回键触发，主要是让应用返回桌面，而不是关闭应用
            put("addFriends", "addFriends");//添加好友
            put("refusedFriends", "refusedFriends");//拒绝好友添加邀请
            put("acceptedFriends", "acceptedFriends");//同意好友添加邀请
            put("getAllContacts", "getAllContacts");//获取好友列表
            put("addUserToBlackList", "addUserToBlackList");//拉入黑名单
            put("getBlackListUsernames", "getBlackListUsernames");//黑名单列表
            put("getBlackListUsernamesFromDataBase", "getBlackListUsernamesFromDataBase");//黑名单列表(数据库)
            put("removeUserFromBlackList", "removeUserFromBlackList");//移出黑名单
            put("deleteContact", "deleteContact");//删除好友
            put("sendMessage", "sendMessage");//发送聊天消息
            put("createFiles", "createFiles");//创建APP文件夹
            put("shootVideo", "shootVideo");//拍摄小视频
        }
    };

    /** flutter调用原生方法的回调
     * @param activity activity
     * @param methodCall methodCall
     * @param result result
     */
    static void onMethodCall(FlutterActivity activity, MethodCall methodCall, final MethodChannel.Result result){
        if(Objects.equals(methodNames.get("register"), methodCall.method)){//注册账号
            EMClientUtils.register(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    Objects.requireNonNull(methodCall.argument("password")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("login"), methodCall.method)){//登录
            EMClientUtils.login(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    Objects.requireNonNull(methodCall.argument("password")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("logout"), methodCall.method)){//退出登录
            EMClientUtils.logout(new CallBack<Boolean>() {
                @Override
                public void call(Object o) {
                    Utils.doOnMainThread(result, o);
                }
            });
        }else if(Objects.equals(methodNames.get("autoLogin"), methodCall.method)){//自动登录
            EMClient.getInstance().groupManager().loadAllGroups();
            EMClient.getInstance().chatManager().loadAllConversations();
        }else if(Objects.equals(methodNames.get("backPress"), methodCall.method)){//返回键返回桌面
            try {
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);// 注意
                intent.addCategory(Intent.CATEGORY_HOME);
                activity.startActivity(intent);
            }catch (Exception e){
                activity.finish();
            }
        }else if(Objects.equals(methodNames.get("addFriends"), methodCall.method)){//添加好友
            EMClientUtils.addFriends(Objects.requireNonNull(methodCall.argument("toAddUsername")).toString(),
                    Objects.requireNonNull(methodCall.argument("reason")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("refusedFriends"), methodCall.method)){//拒绝好友添加邀请
            EMClientUtils.refusedFriends(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("acceptedFriends"), methodCall.method)){//同意好友添加邀请
            EMClientUtils.acceptedFriends(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("getAllContacts"), methodCall.method)){//获取好友列表
            EMClientUtils.getAllContactsFromServer(new CallBack<Boolean>() {
                @Override
                public void call(Object o) {
                    Utils.doOnMainThread(result, o);
                }
            });
        }else if(Objects.equals(methodNames.get("addUserToBlackList"), methodCall.method)){//拉入黑名单
            boolean isNeed = Objects.requireNonNull(methodCall.argument("username")).toString().equals("0");
            EMClientUtils.addUserToBlackList(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    isNeed, new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("getBlackListUsernames"), methodCall.method)){//黑名单列表
            EMClientUtils.getBlackListUsernames(new CallBack<Boolean>() {
                @Override
                public void call(Object o) {
                    Utils.doOnMainThread(result, o);
                }
            });
        }else if(Objects.equals(methodNames.get("getBlackListUsernamesFromDataBase"), methodCall.method)){//黑名单列表
            EMClientUtils.getBlackListUsernamesFromDataBase(new CallBack<Boolean>() {
                @Override
                public void call(Object o) {
                    Utils.doOnMainThread(result, o);
                }
            });
        }else if(Objects.equals(methodNames.get("removeUserFromBlackList"), methodCall.method)){//移出黑名单
            EMClientUtils.removeUserFromBlackList(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("deleteContact"), methodCall.method)){//删除好友
            EMClientUtils.deleteContact(Objects.requireNonNull(methodCall.argument("username")).toString(),
                    new CallBack<Boolean>() {
                        @Override
                        public void call(Object o) {
                            Utils.doOnMainThread(result, o);
                        }
                    });
        }else if(Objects.equals(methodNames.get("sendMessage"), methodCall.method)){//发送聊天消息
            EMMessage message;
            if(Objects.equals(methodCall.argument("contentType"), "text")){//文本
                message = EMMessage.createTxtSendMessage(Objects.requireNonNull(methodCall.argument("content"))
                        .toString(), Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "voice")){//语音
                message = EMMessage.createVoiceSendMessage(Objects.requireNonNull(methodCall.argument("contentUrl"))
                                .toString(), methodCall.argument("length") == null ? 0 : (int) methodCall.argument("length"),
                        Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "video")){//视频
                message = EMMessage.createVideoSendMessage(Objects.requireNonNull(methodCall.argument("contentUrl")).toString(),
                        Objects.requireNonNull(methodCall.argument("thumbPath")).toString(),
                        methodCall.argument("length") == null ? 0 : (int) methodCall.argument("length"),
                        Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "image")){//图像
                message = EMMessage.createImageSendMessage(Objects.requireNonNull(methodCall.argument("contentUrl")).toString(),
                        methodCall.argument("sendOriginalImage") == null && Boolean.valueOf(methodCall.argument("sendOriginalImage").toString()),
                        Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "location")){//位置
                message = EMMessage.createLocationSendMessage(methodCall.argument("latitude") == null ? 0 : (double) methodCall.argument("latitude"),
                        methodCall.argument("longitude") == null ? 0 : (double) methodCall.argument("longitude"),
                        Objects.requireNonNull(methodCall.argument("locationAddress")).toString(),
                        Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "file")){//文件
                message = EMMessage.createFileSendMessage(Objects.requireNonNull(methodCall.argument("filePath")).toString(),
                        Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else if(Objects.equals(methodCall.argument("contentType"), "defined")){//扩展消息
                //拓展消息有自定义属性，取值后赋值message.setAttribute("attribute1", "value");
                message = EMMessage.createTxtSendMessage(Objects.requireNonNull(methodCall.argument("content"))
                        .toString(), Objects.requireNonNull(methodCall.argument("toChatUsername")).toString());
            }else{//其他消息都算是透传消息
                message = EMMessage.createSendMessage(EMMessage.Type.CMD);
            }
            message.setChatType(Utils.getChatType(Objects.requireNonNull(methodCall.argument("chatType")).toString()));
            EMClientUtils.sendMessage(message, new CallBack<Boolean>() {
                @Override
                public void call(Object o) {
                    Utils.doOnMainThread(result, o);
                }
            });
        }else if(Objects.equals(methodNames.get("createFiles"), methodCall.method)) {//创建APP文件夹
            Utils.setFilePath();
        }else if(Objects.equals(methodNames.get("shootVideo"), methodCall.method)) {//拍摄小视频
            Intent intent = new Intent(activity, VideoRecordActivity.class);
            new ActivityResult(activity).startForResult(intent, new ActivityResult.Callback() {
                @Override
                public void onActivityResult(int resultCode, Intent data) {
                    if(data != null){
                        String videoPath = data.getStringExtra("result");
                        String thumbPath = data.getStringExtra("thumbPath");
                        int length = data.getIntExtra("length", 0);
                        Map<String, String> map = new HashMap<>();
                        map.put("videoPath", videoPath);
                        map.put("thumbPath", thumbPath);
                        map.put("length", String.valueOf(length));
                        Utils.doOnMainThread(result, map);
                    }
                }
            });
        }
    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     * @param eventSink eventSink
     */
    static void onListen(FlutterActivity activity, Object o, EventChannel.EventSink eventSink){
        //注册一个监听连接状态的listener
        EMClient.getInstance().addConnectionListener(new ConnectionListener(activity, eventSink));
        //注册一个监听好友状态的listener
        EMClient.getInstance().contactManager().setContactListener(new ContactListener(eventSink));
        //注册一个原生APP状态回调的listener
        Utils.addAppCallBack(new CallBackListener(eventSink));
        //注册消息监听来接收消息
        EMClient.getInstance().chatManager().addMessageListener(MessageListener.get().register(eventSink));
    }

    /**原生调用flutter方法的回调
     * @param activity activity
     * @param o o
     */
    static void onCancel(FlutterActivity activity, Object o) {

    }
}
