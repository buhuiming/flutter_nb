import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/base/base_state.dart';
import 'package:flutter_nb/database/message_database.dart';

/*
* 消息类State基类，监听原生的回调，更新页面
*/
abstract class MessageState<T extends StatefulWidget> extends BaseState<T> {
  MessageDataBase dbHelper = MessageDataBase.get();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dbHelper.close();
  }

  void onEvent(Object event) {
    super.onEvent(event);

  }

  void onError(Object error) {}
}
