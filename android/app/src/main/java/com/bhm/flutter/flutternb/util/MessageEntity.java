package com.bhm.flutter.flutternb.util;

public class MessageEntity {
    private String type;
    private String content_type;
    private String method;
    private String sender_account;
    private String note;
    private String time;

    public MessageEntity(String type, String method, String content_type, String username, String time, String reason){
        this.type = type;
        this.content_type = content_type;
        this.method = method;
        this.sender_account = username;
        this.time = time;
        this.note = reason;
    }
    public MessageEntity(String type, String method, String username, String reason){
        this.type = type;
        this.method = method;
        this.sender_account = username;
        this.note = reason;
    }
    public MessageEntity(String type, String method, String username){
        this.type = type;
        this.method = method;
        this.sender_account = username;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getContent_type() {
        return content_type;
    }

    public void setContent_type(String content_type) {
        this.content_type = content_type;
    }

    public String getSender_account() {
        return sender_account;
    }

    public void setSender_account(String sender_account) {
        this.sender_account = sender_account;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }
}
