package com.bhm.flutter.flutternb.util;

import java.util.HashMap;
import java.util.Map;

public class CallBackData {
    public final static String TYPE_OF_STRING = "string";
    public final static String TYPE_OF_JSON = "json";

    public static Map res = new HashMap();

    public static synchronized Map setData(String type, String content){
        res.clear();
        res.put(type, content);
        return res;
    }
}
