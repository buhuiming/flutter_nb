import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
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
      {OnUpdateCallback callBack, @required BuildContext context}) {
    if (o is String) {
      MessageEntity entity = MessageEntity.fromMap(json.decode(o.toString()));
      String payload;
      bool isShowNotification = false;
      switch (entity.type) {
        case Constants.MESSAGE_TYPE_SYSTEM: //系统消息
          switch (entity.contentType) {
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
                      senderAccount: entity.titleName, isUnreadCount: 1);
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
                      senderAccount: entity.titleName, isUnreadCount: 1);
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
          switch (entity.contentType) {
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
                      senderAccount: entity.titleName, isUnreadCount: 1);
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
                _currentChatName.contains(entity.titleName)) ||
            _currentPageName.contains('SystemMessagePage')) {
          //如果当前页面是SystemMessagePage，或者是ChatPage（且对应聊天对象），则不弹通知
          print('no notification');
        } else {
          NotificationUtil.instance()
              .build(context)
              .showSystem(entity.titleName, entity.content, payload);
        }
      }
    }
  }
}
