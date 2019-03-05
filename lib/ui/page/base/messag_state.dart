import 'package:flutter/material.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/base_state.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/interact_vative.dart';

/*
* 消息类State基类，监听原生的回调，更新页面
*/
abstract class MessageState<T extends StatefulWidget> extends BaseState<T> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListener();
  }

  _addListener() {
    InteractNative.initMessageEvent();
    InteractNative.getMessageEventStream().listen((value) {
      updateData(value);
    });
  }

  @protected
  void updateData(MessageEntity entity);

  void onEvent(Object event) {
    super.onEvent(event);
    Map result = event;
    if (result.containsKey('json')) {
      DataBaseControl.decodeData(result.values.elementAt(0), context: context,
          callBack: (type, unReadCount, entity) {
        entity.isUnreadCount = unReadCount;
        InteractNative.getMessageEventSink().add(entity);
      }); //解析数据保存数据库
    }
  }

  void onError(Object error) {}
}
