package com.bhm.flutter.flutternb.util;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.hyphenate.EMCallBack;
import com.hyphenate.chat.EMClient;

import io.reactivex.Observable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;

/**
 * 调用环信IM统一工具类
 */
@SuppressWarnings("ResultOfMethodCallIgnored")
public class EMClientUtils {

    /** 注册账号
     * @param username username
     * @param pwd pwd
     * @return is success
     */
    public static void register(final String username, final String pwd, final CallBack<Boolean> callBack){
        Observable.just(callBack)
                .observeOn(Schedulers.io())
                .subscribe(new Consumer<CallBack<Boolean>>() {
                    @Override
                    public void accept(CallBack<Boolean> callBack1) throws Exception {
                        EMClient.getInstance().createAccount(username, pwd);//同步方法
                        callBack.call(true);
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        callBack.call(throwable.getMessage());
                    }
                });
    }

    /** 注册账号
     * @param username username
     * @param pwd pwd
     * @return is success
     */
    public static void login(final String username, final String pwd, final CallBack<Boolean> callBack){
        EMClient.getInstance().login(username, pwd ,new EMCallBack() {//回调
            @Override
            public void onSuccess() {
                //以下两个方法是为了保证进入主页面后本地会话和群组都 load 完毕。
                //另外如果登录过，APP 长期在后台再进的时候也可能会导致加载到内存的群组和会话为空，
                //可以在主页面的 oncreate 里也加上这两句代码，当然，更好的办法应该是放在程序的开屏页
                EMClient.getInstance().groupManager().loadAllGroups();
                EMClient.getInstance().chatManager().loadAllConversations();
                callBack.call(true);
            }
            @Override
            public void onProgress(int progress, String status) {
            }
            @Override
            public void onError(int code, String message) {
                callBack.call(message);
            }
        });
    }

    /** 退出登录
     * @return is success
     */
    public static void logout(final CallBack<Boolean> callBack){
        EMClient.getInstance().logout(true, new EMCallBack() {
            @Override
            public void onSuccess() {
                // TODO Auto-generated method stub
                callBack.call(true);
            }
            @Override
            public void onProgress(int progress, String status) {
                // TODO Auto-generated method stub
            }
            @Override
            public void onError(int code, String message) {
                // TODO Auto-generated method stub
                callBack.call(message);
            }
        });
    }

    /** 添加好友
     * @param toAddUsername 好友帐号
     * @param reason 验证信息
     * @param callBack
     */
    public static void addFriends(final String toAddUsername, final String reason, final CallBack<Boolean> callBack){
        Observable.just(callBack)
                .observeOn(Schedulers.io())
                .subscribe(new Consumer<CallBack<Boolean>>() {
                    @Override
                    public void accept(CallBack<Boolean> callBack1) throws Exception {
                        EMClient.getInstance().contactManager().addContact(toAddUsername, reason);//同步方法
                        callBack.call(true);
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        callBack.call(throwable.getMessage());
                    }
                });
    }

    /** 拒绝好友添加邀请
     * @param username 帐号
     * @param callBack
     */
    public static void refusedFriends(final String username,final CallBack<Boolean> callBack){
        Observable.just(callBack)
                .observeOn(Schedulers.io())
                .subscribe(new Consumer<CallBack<Boolean>>() {
                    @Override
                    public void accept(CallBack<Boolean> callBack1) throws Exception {
                        EMClient.getInstance().contactManager().declineInvitation(username);//同步方法
                        callBack.call(true);
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        callBack.call(throwable.getMessage());
                    }
                });
    }
}
