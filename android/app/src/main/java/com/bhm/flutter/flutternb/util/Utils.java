package com.bhm.flutter.flutternb.util;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Point;
import android.os.Build;
import android.os.Environment;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.listeners.MessageListener;
import com.hyphenate.chat.EMMessage;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;

@SuppressWarnings("ResultOfMethodCallIgnored")
public class Utils {

    private static final List<CallBack> callBacks = new ArrayList<>();

    public static void addAppCallBack(CallBack callBack){
        if(callBack != null && !callBacks.contains(callBack)){
            callBacks.add(callBack);
        }
    }

    public static void removeAppCallBack(CallBack callBack){
        if(callBack != null){
            callBacks.remove(callBack);
        }
    }

    public static void setCallBack(Object o){
        for(CallBack callBack : callBacks){
            callBack.call(o);
        }
        //记得在不需要的时候移除listener，如在activity的onDestroy()时
        MessageListener.get().unRegister();
    }

    public static String getAppName(Context context, int pID) {
        String processName = "";
        ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        if(am == null)
            return "";
        List l = am.getRunningAppProcesses();
        Iterator i = l.iterator();
        PackageManager pm = context.getPackageManager();
        while (i.hasNext()) {
            ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo) (i.next());
            try {
                if (info.pid == pID) {
                    processName = info.processName;
                    return processName;
                }
            } catch (Exception e) {
                // Log.d("Process", "Error>> :"+ e.toString());
            }
        }
        return processName;
    }

    public static void setStatus(Activity activity){
        if(!isNavigationBarShow(activity)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);//窗口透明的状态栏
                activity.requestWindowFeature(Window.FEATURE_NO_TITLE);//隐藏标题栏
                activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);//窗口透明的导航栏
            }
        }else{
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                activity.getWindow().setStatusBarColor(Color.TRANSPARENT);
            }
        }
    }

    private static boolean isNavigationBarShow(Activity activity){
        Display display = activity.getWindowManager().getDefaultDisplay();
        Point size = new Point();
        Point realSize = new Point();
        display.getSize(size);
        display.getRealSize(realSize);
        boolean  result  = realSize.y!=size.y;
        return realSize.y!=size.y;
    }

    public static String getChatType(EMMessage message){
        String chatType;
        if(message.getChatType() == EMMessage.ChatType.Chat){
            chatType = "chat";
        }else if(message.getChatType() == EMMessage.ChatType.ChatRoom){
            chatType = "chatRoom";
        }else if(message.getChatType() == EMMessage.ChatType.GroupChat){
            chatType = "chatGroup";
        }else{
            chatType = "chat";
        }
        return chatType;
    }

    public static String getType(EMMessage.Type type){
        String result;
        if(type == EMMessage.Type.TXT){
            result = "text";
        }else if(type == EMMessage.Type.VOICE){
            result = "voice";
        }else if(type == EMMessage.Type.VIDEO){
            result = "video";
        }else if(type == EMMessage.Type.IMAGE){
            result = "image";
        }else if(type == EMMessage.Type.LOCATION){
            result = "location";
        }else if(type == EMMessage.Type.FILE){
            result = "file";
        }else if(type == EMMessage.Type.CMD){
            result = "cmd";
        }else{
            result = "defined";
        }
        return result;
    }

    public static EMMessage.ChatType getChatType(String type){
        EMMessage.ChatType chatType;
        if("chat".equals(type)){
            chatType = EMMessage.ChatType.Chat;
        }else if("chatRoom".equals(type)){
            chatType = EMMessage.ChatType.ChatRoom;
        }else if("chatGroup".equals(type)){
            chatType = EMMessage.ChatType.GroupChat;
        }else{
            chatType = EMMessage.ChatType.Chat;
        }
        return chatType;
    }

    public static void setFilePath(){
        Observable.just(1)
                .observeOn(Schedulers.io())
                .subscribe(new Consumer<Integer>() {
                    @Override
                    public void accept(Integer integer) throws Exception {
                        String dir = Environment.getExternalStorageDirectory().getAbsolutePath()
                                + File.separator;
                        File fileVoice = new File(dir + "BHMFlutter/voice");
                        deleteFile(fileVoice, 1000);
                        File fileVideo = new File(dir + "BHMFlutter/video");
                        deleteFile(fileVideo, 2000);
                        if(!fileVoice.exists()){
                            fileVoice.mkdirs();
                        }
                        if(!fileVideo.exists()){
                            fileVideo.mkdirs();
                        }
                    }

                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {

                    }
                });
    }

    private static void deleteFile(File file, int count){
        if(file.isDirectory()){
            File[] childFiles = file.listFiles();
            if(childFiles == null){
                return;
            }
            //根据时间排序
            Arrays.sort(childFiles, new Comparator<File>() {
                public int compare(File p1, File p2) {
                    if (p1.lastModified() < p2.lastModified()) {
                        return -1;
                    }
                    return 1;
                }
            });
            if(childFiles.length >= count){//超过count后，把超出的部分删除（删除最早的）
                for (int i = 0; i < childFiles.length - count; i++) {
                    childFiles[i].delete();
                }
            }
        }
    }

    public static void doOnMainThread(EventChannel.EventSink mSink, Object o){
        Observable.just(1L)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(aLong -> mSink.success(o));
    }

    public static void doOnMainThread(MethodChannel.Result result, Object o){
        Observable.just(1L)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(aLong -> result.success(o));
    }
}
