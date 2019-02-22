/*
* 消息类实体
*/
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';

class MessageEntity {
  static const String DB_ID = "id"; //自增长id
  static const String TYPE = "type"; //消息类型，不可以为空
  static const String IMAGE_URL = "image_url"; //头像链接，可以为空
  static const String IS_UNREAD = "is_unread"; //0未读,1已读
  static const String SENDER_ACCOUNT = "sender_account"; //不发送方，可以为空
  static const String TITLE_NAME = "title_name"; //标题或者名字，不可以为空
  static const String CONTENT = "content"; //内容，不可以为空
  static const String CONTENT_TYPE = "content_type"; //内容类型，可以为空
  static const String CONTENT_URL = "content_url"; //内容链接，比如类型为图片，则是图片链接，可以为空
  static const String TIME = "time"; //消息发送时间，不可以为空
  static const String MESSAGE_OWNER = "message_owner"; //消息发送方，0自己,1对方
  static const String IS_REMIND = "is_remind"; //是否提醒 0不提醒,1提醒
  static const String IS_UNREAD_COUNT = "is_unread_count"; //未读数
  static const String NOTE = "note"; //备注

  String type,
      imageUrl,
      senderAccount,
      titleName,
      content,
      contentType,
      contentUrl,
      time,
      note;
  int id;
  int isUnread, messageOwner, isRemind, isUnreadCount;
  MessageEntity(
      {@required this.type,
      this.imageUrl = '',
      @required this.senderAccount,
      @required this.titleName,
      @required this.content,
      this.contentType = Constants.CONTENT_TYPE_SYSTEM,
      this.contentUrl = '',
      @required this.time,
      this.note = '',
      this.isUnread = 0,
      this.messageOwner = 1,
      this.isRemind = 1,
      this.id,
      this.isUnreadCount =
          0 //此字段不保存数据库，取值为MessageTypeEntity[isUnreadCount]，主要用来entity数据临时存取
      });

  MessageEntity.fromMap(Map<String, dynamic> map)
      : this(
          id: map[DB_ID],
          type: map[TYPE],
          imageUrl: map[IMAGE_URL],
          senderAccount: map[SENDER_ACCOUNT],
          titleName: map[TITLE_NAME],
          content: map[CONTENT],
          contentType: map[CONTENT_TYPE],
          contentUrl: map[CONTENT_URL],
          time: map[TIME],
          isUnread: map[IS_UNREAD],
          messageOwner: map[MESSAGE_OWNER],
          isRemind: map[IS_REMIND],
          note: map[NOTE],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      TYPE: type,
      IMAGE_URL: imageUrl,
      SENDER_ACCOUNT: senderAccount,
      TITLE_NAME: titleName,
      CONTENT: content,
      CONTENT_TYPE: contentType,
      CONTENT_URL: contentUrl,
      TIME: time,
      IS_UNREAD: isUnread,
      MESSAGE_OWNER: messageOwner,
      IS_REMIND: isRemind,
      NOTE: note,
    };
  }
}

/*
* 消息列表类实体
*/
class MessageTypeEntity {
  static const String DB_ID = "id"; //自增长id
  static const String SENDER_ACCOUNT = "sender_account"; //发送方
  static const String IS_UNREAD_COUNT = "is_unread_count"; //未读数

  String senderAccount;
  int id;
  int isUnreadCount;

  MessageTypeEntity({
    @required this.senderAccount,
    this.id,
    this.isUnreadCount = 0,
  });

  MessageTypeEntity.fromMap(Map<String, dynamic> map)
      : this(
          senderAccount: map[SENDER_ACCOUNT],
          isUnreadCount: map[IS_UNREAD_COUNT],
          id: map[DB_ID],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      SENDER_ACCOUNT: senderAccount,
      IS_UNREAD_COUNT: isUnreadCount,
    };
  }
}
