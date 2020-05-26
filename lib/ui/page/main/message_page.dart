import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/page/chat_page.dart';
import 'package:flutter_nb/ui/page/system_message_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/timeline_util.dart';
import 'package:rxdart/rxdart.dart';

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

class Message extends MessageState<MessagePage> with WidgetsBindingObserver {
  var map = Map(); //key,value，跟进list的key查找value
  var list = new List(); //存key,根据最新的消息插入0位置
  bool isShowNoPage = false;
  Timer _refreshTimer;
  AppLifecycleState currentState = AppLifecycleState.resumed;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  var _popString = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds: 1200), () {
      NotificationUtil.instance().cancelMessage();
    });
    _popString.add('标记未读');
    _popString.add('顶置消息');
    _popString.add('删除消息');
    _getData();
    _startRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
        key: _key,
        appBar: MoreWidgets.buildAppBar(context, '消息'),
        body: new Stack(
          children: <Widget>[
            new Offstage(
              offstage: isShowNoPage,
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _itemWidget(index);
                  },
                  itemCount: list.length),
            ),
            new Offstage(
              offstage: !isShowNoPage,
              child: MoreWidgets.buildNoDataPage(), //显示loading，则禁掉返回按钮和右滑关闭
            )
          ],
        ));
  }

  Widget _itemWidget(int index) {
    Widget res;
    MessageEntity entity = map[list.elementAt(index).toString()];
    res = MoreWidgets.messageListViewItem(entity.imageUrl, entity.titleName, entity.contentType,
        content: entity.content,
        time: TimelineUtil.format(int.parse(entity.time)),
        unread: entity.isUnreadCount, onItemClick: (res) {
      if (entity.type == Constants.MESSAGE_TYPE_SYSTEM) {
        //系统消息，跳转系统消息列表
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => SystemMessagePage()));
      } else if (entity.type == Constants.MESSAGE_TYPE_CHAT) {
        //聊天消息，跳转聊天对话页面
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => ChatPage(
                      operation: widget.operation,
                      title: entity.titleName,
                      senderAccount: entity.senderAccount,
                    )));
      } else if (entity.type == Constants.MESSAGE_TYPE_GROUP_CHAT) {
        //群聊消息，跳转群聊页面
      } else if (entity.type == Constants.MESSAGE_TYPE_ROOM_CHAT) {
        //聊天室消息，跳转聊天室
      }
    }, onItemLongClick: (res) {
      MoreWidgets.buildMessagePop(context, _popString, onItemClick: (res) {
        switch (res) {
          case 'one':
            DialogUtil.buildSnakeBarByKey('标记未读功能未实现', _key);
            break;
          case 'two':
            DialogUtil.buildSnakeBarByKey('顶置消息功能未实现', _key);
            break;
          case 'three':
            DialogUtil.showBaseDialog(context, '删除后将清空该聊天的消息记录',
                right: '删除', left: '再想想', rightClick: (res) {
              _deleteAll(entity);
            });
            break;
        }
      });
    });
    return res;
  }

  Future _deleteAll(MessageEntity entity) async {
    String table = entity.senderAccount;
    String name = entity.senderAccount;
    if (entity.type == Constants.MESSAGE_TYPE_SYSTEM) {
      table = Constants.MESSAGE_TYPE_SYSTEM;
      name = Constants.MESSAGE_TYPE_SYSTEM_ZH;
    }
    MessageDataBase.get()
        .deleteMessageTypeEntity(entity: MessageTypeEntity(senderAccount: name))
        .then((value) {
      MessageDataBase.get().deleteMessageEntity(table).then((res) {
        _getData();
      });
    });
  }

  _getData() async {
    MessageDataBase.get().getMessageTypeEntity().then((listTypeEntity) async {
      if (listTypeEntity.length > 0) {
        list.clear();
        map.clear();
        listTypeEntity.forEach((typeEntity) {
          String type = typeEntity.senderAccount;
          if (type == Constants.MESSAGE_TYPE_SYSTEM_ZH) {
            type = Constants.MESSAGE_TYPE_SYSTEM;
          }
          MessageDataBase.get()
              .getMessageEntityInType(type)
              .then((listEntity) async {
            if (null != listEntity && listEntity.length > 0) {
              MessageEntity messageEntity =
                  listEntity.elementAt(listEntity.length - 1);
              messageEntity.isUnreadCount = typeEntity.isUnreadCount;
              if (list.contains(messageEntity.titleName)) {
                //如果已经存在
                list.remove(messageEntity.titleName);
                map.remove(messageEntity.titleName);
              }
              list.insert(0, messageEntity.titleName);
              map[messageEntity.titleName] = messageEntity;
            }
            setState(() {
              isShowNoPage = list.length <= 0;
            });
          });
        });
      } else {
        setState(() {
          list.clear();
          map.clear();
          isShowNoPage = true;
        });
      }
    });
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
    if (currentState == AppLifecycleState.resumed) {
      setState(() {

      });
    }
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

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
    if (null != entity) {
      if (entity.type == Constants.MESSAGE_TYPE_SYSTEM ||
          entity.type == Constants.MESSAGE_TYPE_CHAT) {
        if (entity.method == DataBaseControl.payload_contact_contactDeleted) {
          //好友删除
          list.remove(entity.titleName);
          map.remove(entity.titleName);
          setState(() {
            isShowNoPage = list.length <= 0;
          });
        } else {
          if (list.contains(entity.titleName)) {
            //如果已经存在
            list.remove(entity.titleName);
            map.remove(entity.titleName);
          }
          list.insert(0, entity.titleName);
          map[entity.titleName] = entity;
          setState(() {
            isShowNoPage = list.length <= 0;
          });
        }
      } else if (entity.type == InteractNative.SYSTEM_MESSAGE_HAS_READ) {
        if (null != map && map.length > 0 && list.length > 0) {
          map[entity.senderAccount].isUnreadCount = 0;
        }
      } else if (entity.type == InteractNative.SYSTEM_MESSAGE_DELETE_ALL ||
          entity.type == InteractNative.SYSTEM_MESSAGE_DELETE) {
        _getData();
      }
    }
  }
}
