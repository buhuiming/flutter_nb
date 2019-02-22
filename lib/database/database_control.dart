import 'dart:convert';

import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
* 数据库处理类
*/
class DataBaseControl {
  /*
  *  解析数据
  */
  static void decodeData(Object o, {OnUpdateCallback callBack}) {
    if (o is String) {
      MessageEntity entity = MessageEntity.fromMap(json.decode(o.toString()));
      switch (entity.type) {
        case Constants.MESSAGE_TYPE_SYSTEM: //系统消息
          switch (entity.contentType) {
            case 'onContactInvited': //收到好友邀请
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
          break;
      }
    }
  }
}
