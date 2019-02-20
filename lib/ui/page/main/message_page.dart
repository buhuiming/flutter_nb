import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/file_util.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Message();
  }
}

class Message extends MessageState<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '消息'),
      body: new ListView(
        children: <Widget>[
          MoreWidgets.messageListViewItem(
              FileUtil.getImagePath('system_message',
                  dir: 'icon', format: 'png'),
              '系统消息',
              content: '您的好友申请通过了',
              time: '15:38',
              unread: 1),
          MoreWidgets.messageListViewItem(
              FileUtil.getImagePath('logo', dir: 'splash', format: 'png'),
              '习近平',
              content: '你的要求已经批准！',
              time: '13:56'),
          MoreWidgets.messageListViewItem(
              FileUtil.getImagePath('logo', dir: 'splash', format: 'png'),
              '陈冠希',
              content: '有空再一起开黑呀，下次让我来带你飞，先这样',
              time: '12:11'),
          MoreWidgets.messageListViewItem(
              FileUtil.getImagePath('logo', dir: 'splash', format: 'png'), '姚明',
              content: '好的', time: '10:21'),
          MoreWidgets.messageListViewItem(
              FileUtil.getImagePath('logo', dir: 'splash', format: 'png'),
              'Jospter',
              content: 'see you',
              time: '08:33'),
        ],
      ),
    );
  }
}
