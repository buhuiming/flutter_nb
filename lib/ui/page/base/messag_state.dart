import 'package:flutter/material.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/utils/interact_vative.dart';

/*
* 消息类State基类，监听原生的回调，更新页面
*/
abstract class MessageState<T extends StatefulWidget> extends State<T> {
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
}
