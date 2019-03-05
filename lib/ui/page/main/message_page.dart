import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/page/system_message_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/timeline_util.dart';

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

class Message extends MessageState<MessagePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  var map = Map(); //key,value，跟进list的key查找value
  var list = new List(); //存key,根据最新的消息插入0位置
  bool isShowNoPage = false;
  Timer _refreshTimer;
  AppLifecycleState currentState = AppLifecycleState.resumed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationUtil.instance().cancelMessage();
    _getData();
    _startRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
        appBar: MoreWidgets.buildAppBar(context, '消息'),
        body: !isShowNoPage
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _itemWidget(index);
                },
                itemCount: list.length)
            : MoreWidgets.buildNoDataPage());
  }

  Widget _itemWidget(int index) {
    Widget res;
    MessageEntity entity = map[list.elementAt(index).toString()];
    res = MoreWidgets.messageListViewItem(entity.imageUrl, entity.titleName,
        content: entity.content,
        time: TimelineUtil.format(int.parse(entity.time)),
        unread: entity.isUnreadCount, onItemClick: (res) {
      if (entity.type == Constants.MESSAGE_TYPE_SYSTEM) {
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => SystemMessagePage()));
      }
    });
    return res;
  }

  _getData() {
    MessageDataBase.get().getMessageTypeEntity().then((listTypeEntity) {
      if (listTypeEntity.length > 0) {
        listTypeEntity.forEach((typeEntity) {
          String type = typeEntity.senderAccount;
          if (type == '系统消息') {
            type = Constants.MESSAGE_TYPE_SYSTEM;
          }
          MessageDataBase.get().getMessageEntityInType(type).then((listEntity) {
            if (null != listEntity && listEntity.length > 0) {
              MessageEntity messageEntity =
                  listEntity.elementAt(listEntity.length - 1);
              messageEntity.isUnreadCount = listTypeEntity.length;
              if (type == Constants.MESSAGE_TYPE_SYSTEM) {
                if (list.contains(messageEntity.titleName)) {
                  //如果已经存在
                  list.remove(messageEntity.titleName);
                  map.remove(messageEntity.titleName);
                }
                list.insert(0, messageEntity.titleName);
                map[messageEntity.titleName] = messageEntity;
              }
            }
            isShowNoPage = list.length <= 0;
            setState(() {});
          });
        });
      } else {
        isShowNoPage = list.length <= 0;
        setState(() {});
      }
    });
  }

  @override
  void notify(String type, MessageEntity entity) {
    if (null != entity) {
      if (type == Constants.MESSAGE_TYPE_SYSTEM) {
        if (list.contains(entity.titleName)) {
          //如果已经存在
          list.remove(entity.titleName);
          map.remove(entity.titleName);
        }
        list.insert(0, entity.titleName);
        map[entity.titleName] = entity;
      }
      isShowNoPage = list.length <= 0;
      setState(() {});
    }
  }

  /*
  * 定时刷新
  */
  _startRefresh() {
    _refreshTimer =
        Timer.periodic(const Duration(milliseconds: 1000 * 60), _handleTime);
  }

  _handleTime(Timer timer) {
    //当APP在前台，且当前页是0（即本页），则刷新
    if (null != currentState &&
        currentState != AppLifecycleState.paused &&
        Constants.currentPage == 0) {
      setState(() {
        print('refresh data');
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    //initState后，未调用，所以初始化为resume，当APP进入后台，则为onPause；APP进入前台，为resume
    currentState = state;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (null != _refreshTimer) {
      _refreshTimer.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
