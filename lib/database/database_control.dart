import 'dart:convert';

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
  static const String payload_contact_invited = 'onContactInvited';

  /*
  *  解析数据
  */
  static void decodeData(Object o, {OnUpdateCallback callBack}) {
    if (o is String) {
      MessageEntity entity = MessageEntity.fromMap(json.decode(o.toString()));
      String payload;
      switch (entity.type) {
        case Constants.MESSAGE_TYPE_SYSTEM: //系统消息
          switch (entity.contentType) {
            case payload_contact_invited: //收到好友邀请
              payload = payload_contact_invited;
              entity.imageUrl = FileUtil.getImagePath('system_message',
                  dir: 'icon', format: 'png');
              entity.contentUrl = '';
              entity.messageOwner = 1;
              entity.isUnread = 0;
              entity.isRemind = 1;
              entity.titleName = '系统消息';
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
                      isUnreadCount: 1);
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
          if (SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != false &&
              SPUtil.getBool(Constants.NOTIFICATION_KEY_SYSTEM) != false) {
            NotificationUtil.build()
                .showSystem(entity.titleName, entity.content, payload);
          }
          break;
      }
    }
  }
}
