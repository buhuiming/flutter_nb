package com.bhm.flutter.flutternb.util;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Point;
import android.os.Build;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;

import com.bhm.flutter.flutternb.interfaces.CallBack;
import com.bhm.flutter.flutternb.listeners.MessageListener;
import com.hyphenate.chat.EMMessage;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

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
}
