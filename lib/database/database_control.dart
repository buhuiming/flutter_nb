import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_body_eneity.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
* 数据库处理类
*/
class DataBaseControl {
  static const String payload_contact_invited = 'onContactInvited'; //添加好友邀请
  static const String payload_contact_request =
      'onFriendRequestDeclined'; //邀请被拒绝
  static const String payload_contact_accepted =
      'onFriendRequestAccepted'; //邀请已同意
  static const String payload_contact_contactAdded =
      'onContactAdded'; //同意通过，返回添加的好友
  static const String payload_contact_contactDeleted =
      'onContactDeleted'; //删除好友
  static const String onMessageReceived = 'onMessageReceived'; //接收到聊天消息
  static List _currentPageName = List();
  static List _currentChatName = List();

  static void setCurrentPageName(String pageName, {String chatName}) {
    if (!_currentPageName.contains(pageName)) {
      _currentPageName.add(pageName);
    }
    if (chatName != null && !_currentChatName.contains(chatName)) {
      _currentChatName.add(chatName);
    }
  }

  static void removeCurrentPageName(String pageName, {String chatName}) {
    _currentPageName.remove(pageName);
    if (chatName != null) {
      _currentChatName.remove(chatName);
    }
  }

  /*
  *  解析数据
  */
  static void decodeData(Object o,
      {OnUpdateCallback callBack,
        @required BuildContext context,
        Operation operation}) {
    if (o is String) {
      MessageEntity entity = MessageEntity.fromMap(json.decode(o.toString()));
      String payload;
      bool isShowNotification = false;
      switch (entity.type) {
        case Constants.MESSAGE_TYPE_SYSTEM: //系统消息
          switch (entity.method) {
            case payload_contact_invited: //收到好友邀请
              isShowNotification = true;
              payload = payload_contact_invited;
              entity.imageUrl = FileUtil.getImagePath('system_message',
                  dir: 'icon', format: 'png');
              entity.contentUrl = '';
              entity.messageOwner = 1;
              entity.isUnread = 0;
              entity.isRemind = 1;
              entity.status = 'untreated'; //未处理，refused已拒绝，agreed已同意
              entity.titleName = Constants.MESSAGE_TYPE_SYSTEM_ZH;
              entity.content = '您收到一个好友添加邀请，${entity.senderAccount}请求添加您为好友！';
              entity.time =
                  new DateTime.now().millisecondsSinceEpoch.toString(); //微秒时间戳
              MessageDataBase.get()
                  .insertMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, entity)
                  .then((onValue) {
                int unReadCount = 0; //先查询出未读数，再加1
                MessageDataBase.get()
                    .getOneMessageUnreadCount(entity.titleName)
                    .then((onValue) {
                  unReadCount = onValue + 1;
                  MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
                      senderAccount: entity.titleName,
                      isUnreadCount: unReadCount);
                  MessageDataBase.get()
                      .insertMessageTypeEntity(messageTypeEntity);
                  if (null != callBack) {
                    callBack(
                        Constants.MESSAGE_TYPE_SYSTEM, unReadCount, entity);
                  }
                });
              }); //保存数据库
              break;
            case payload_contact_request: //收到好友拒绝
              isShowNotification = true;
              payload = payload_contact_request;
              entity.imageUrl = FileUtil.getImagePath('system_message',
                  dir: 'icon', format: 'png');
              entity.contentUrl = '';
              entity.messageOwner = 1;
              entity.isUnread = 0;
              entity.isRemind = 1;
              entity.status = 'refused'; //未处理，refused已拒绝，agreed已同意
              entity.titleName = Constants.MESSAGE_TYPE_SYSTEM_ZH;
              entity.content = '用户${entity.senderAccount}拒绝您的好友添加邀请！';
              entity.time =
                  new DateTime.now().millisecondsSinceEpoch.toString(); //微秒时间戳
              MessageDataBase.get()
                  .insertMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, entity)
                  .then((onValue) {
                int unReadCount = 0; //先查询出未读数，再加1
                MessageDataBase.get()
                    .getOneMessageUnreadCount(entity.titleName)
                    .then((onValue) {
                  unReadCount = onValue + 1;
                  MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
                      senderAccount: entity.titleName,
                      isUnreadCount: unReadCount);
                  MessageDataBase.get()
                      .insertMessageTypeEntity(messageTypeEntity);
                  if (null != callBack) {
                    callBack(
                        Constants.MESSAGE_TYPE_SYSTEM, unReadCount, entity);
                  }
                });
              }); //保存数据库
              break;
            case payload_contact_accepted: //收到好友同意
              isShowNotification = true;
              payload = payload_contact_accepted;
              entity.imageUrl = FileUtil.getImagePath('system_message',
                  dir: 'icon', format: 'png');
              entity.contentUrl = '';
              entity.messageOwner = 1;
              entity.isUnread = 0;
              entity.isRemind = 1;
              entity.status = 'agreed'; //未处理，refused已拒绝，agreed已同意
              entity.titleName = Constants.MESSAGE_TYPE_SYSTEM_ZH;
              entity.content = '用户${entity.senderAccount}同意您的好友添加邀请！';
              entity.time =
                  new DateTime.now().millisecondsSinceEpoch.toString(); //微秒时间戳
              MessageDataBase.get()
                  .insertMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, entity)
                  .then((onValue) {
                int unReadCount = 0; //先查询出未读数，再加1
                MessageDataBase.get()
                    .getOneMessageUnreadCount(entity.titleName)
                    .then((onValue) {
                  unReadCount = onValue + 1;
                  MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
                      senderAccount: entity.titleName,
                      isUnreadCount: unReadCount);
                  MessageDataBase.get()
                      .insertMessageTypeEntity(messageTypeEntity);
                  if (null != callBack) {
                    callBack(
                        Constants.MESSAGE_TYPE_SYSTEM, unReadCount, entity);
                  }
                });
              }); //保存数据库
              break;
          }
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != true &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_SYSTEM) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_SYSTEM) != true) {
            isShowNotification = false;
          }
          break;
        case Constants.MESSAGE_TYPE_CHAT: //聊天消息
          switch (entity.method) {
            case payload_contact_contactAdded: //好友同意后，返回好友信息
              isShowNotification = false; //不需要弹通知栏
              payload = payload_contact_contactAdded;
              entity.imageUrl = FileUtil.getImagePath('img_headportrait',
                  dir: 'icon', format: 'png');
              entity.contentUrl = '';
              entity.messageOwner = 1;
              entity.isUnread = 0;
              entity.isRemind = 1;
              entity.titleName = entity.senderAccount;
              entity.content = '我们已经是好友了，开始聊天吧！';
              entity.time =
                  new DateTime.now().millisecondsSinceEpoch.toString(); //微秒时间戳
              MessageDataBase.get()
                  .insertMessageEntity(entity.titleName, entity)
                  .then((onValue) async {
                int unReadCount = 0; //先查询出未读数，再加1
                MessageDataBase.get()
                    .getOneMessageUnreadCount(entity.titleName)
                    .then((onValue) async {
                  unReadCount = onValue + 1;
                  MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
                      senderAccount: entity.titleName,
                      isUnreadCount: unReadCount);
                  MessageDataBase.get()
                      .insertMessageTypeEntity(messageTypeEntity);
                  if (null != callBack) {
                    callBack(
                        Constants.MESSAGE_TYPE_SYSTEM, unReadCount, entity);
                  }
                });
              });
              break;
            case payload_contact_contactDeleted: //删除好友，刷新列表
              isShowNotification = false; //不需要弹通知栏
              entity.titleName = entity.senderAccount;
              MessageDataBase.get()
                  .deleteMessageTypeEntity(
                  entity: MessageTypeEntity(
                      senderAccount: entity.senderAccount))
                  .then((res) {
                MessageDataBase.get()
                    .deleteMessageEntity(entity.senderAccount)
                    .then((result) {
                  if (null != callBack) {
                    callBack(Constants.MESSAGE_TYPE_SYSTEM, 0, entity);
                  }
                });
              });
              break;
            case onMessageReceived: //接收到聊天消息
              isShowNotification = true;
              payload = o.toString();
              _dealChatMessage(entity, callBack);
              break;
          }
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != true &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != true) {
            isShowNotification = false;
          }
          break;
        case Constants.MESSAGE_TYPE_GROUP_CHAT: //群聊消息
          switch (entity.method) {
            case onMessageReceived: //接收到聊天消息
              isShowNotification = true;
              _dealChatMessage(entity, callBack);
              break;
          }
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != true &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != true) {
            isShowNotification = false;
          }
          break;
        case Constants.MESSAGE_TYPE_ROOM_CHAT: //聊天室消息
          switch (entity.method) {
            case onMessageReceived: //接收到聊天消息
              isShowNotification = true;
              _dealChatMessage(entity, callBack);
              break;
          }
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != true &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_CHAT) != true) {
            isShowNotification = false;
          }
          break;
        case Constants.MESSAGE_TYPE_OTHERS: //其他消息
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != true &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_OTHERS) != null &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_OTHERS) != true) {
            isShowNotification = false;
          }
          break;
      }
      if (isShowNotification) {
        if ((_currentPageName.contains('ChatPage') &&
            _currentChatName.contains(entity.senderAccount)) ||
            _currentPageName.contains('SystemMessagePage')) {
          //如果当前页面是SystemMessagePage，或者是ChatPage（且对应聊天对象），则不弹通知
          print('no notification');
        } else {
          String content = entity.content;
          if(content == null || content == ''){
            if(entity.contentType == Constants.CONTENT_TYPE_VOICE){
              content = '[语音]';
            }else if(entity.contentType == Constants.CONTENT_TYPE_VIDEO){
              content = '[视频]';
            }else if(entity.contentType == Constants.CONTENT_TYPE_IMAGE){
              content = '[图片]';
            }
          }
          NotificationUtil.instance()
              .build(context, operation)
              .showSystem(entity.titleName, content, payload);
        }
      }
    }
  }

  static void _dealChatMessage(
      MessageEntity entity, OnUpdateCallback callBack) {
    MessageBodyEntity bodyEntity =
    MessageBodyEntity.fromMap(json.decode(entity.note));
    switch (entity.contentType) {
      case Constants.CONTENT_TYPE_SYSTEM: //文本
        entity.imageUrl = FileUtil.getImagePath('img_headportrait',
            dir: 'icon', format: 'png'); //这里取本地的，实际要取entity中的
        entity.contentUrl = bodyEntity.message;
        entity.note = '';
        entity.status = '0';
        entity.messageOwner = 1;
        entity.isUnread = 0;
        entity.isRemind = 1;
        entity.titleName = entity.senderAccount;
        entity.content = bodyEntity.message;
        break;
      case Constants.CONTENT_TYPE_VOICE: //语音
        entity.imageUrl = FileUtil.getImagePath('img_headportrait',
            dir: 'icon', format: 'png'); //这里取本地的，实际要取entity中的
        entity.contentUrl = bodyEntity.remoteUrl;//这里取的是远程图，且不做缓存
        entity.note = '';
        entity.status = '0';
        entity.messageOwner = 1;
        entity.isUnread = 0;
        entity.isRemind = 1;
        entity.height = bodyEntity.height;
        entity.width = bodyEntity.width;
        entity.titleName = entity.senderAccount;
        entity.content = bodyEntity.message;
        entity.length = bodyEntity.length;
        break;
      case Constants.CONTENT_TYPE_VIDEO: //视频
        entity.imageUrl = FileUtil.getImagePath('img_headportrait',
            dir: 'icon', format: 'png'); //这里取本地的，实际要取entity中的
        entity.contentUrl = bodyEntity.remoteUrl;//这里取的是远程视频，且不做缓存
        entity.note = '';
        entity.status = '0';
        entity.messageOwner = 1;
        entity.isUnread = 0;
        entity.isRemind = 1;
        entity.height = bodyEntity.height;
        entity.width = bodyEntity.width;
        entity.titleName = entity.senderAccount;
        entity.content = bodyEntity.message;
        entity.length = bodyEntity.duration;
        entity.thumbPath = bodyEntity.thumbnailUrl;
        break;
      case Constants.CONTENT_TYPE_IMAGE: //图像
        entity.imageUrl = FileUtil.getImagePath('img_headportrait',
            dir: 'icon', format: 'png'); //这里取本地的，实际要取entity中的
        entity.contentUrl = bodyEntity.remoteUrl;//这里取的是远程图，且不做缓存
        entity.note = '';
        entity.status = '0';
        entity.messageOwner = 1;
        entity.isUnread = 0;
        entity.isRemind = 1;
        entity.height = bodyEntity.height;
        entity.width = bodyEntity.width;
        entity.titleName = entity.senderAccount;
        entity.content = bodyEntity.message;
        break;
      case Constants.CONTENT_TYPE_LOCATION: //位置
        break;
      case Constants.CONTENT_TYPE_FILE: //文件
        break;
      case Constants.CONTENT_TYPE_CMD: //透传消息
        break;
      case Constants.CONTENT_TYPE_DEFINED: //自定义（拓展消息）
        break;
    }

    MessageDataBase.get()
        .insertMessageEntity(entity.titleName, entity)
        .then((onValue) async {
      int unReadCount = 0; //先查询出未读数，再加1
      MessageDataBase.get()
          .getOneMessageUnreadCount(entity.titleName)
          .then((onValue) async {
        unReadCount = onValue + 1;
        MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
            senderAccount: entity.titleName, isUnreadCount: unReadCount);
        MessageDataBase.get().insertMessageTypeEntity(messageTypeEntity);
        if (null != callBack) {
          callBack(Constants.MESSAGE_TYPE_SYSTEM, unReadCount, entity);
        }
      });
    });
  }
}
