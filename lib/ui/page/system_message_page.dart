import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/timeline_util.dart';

/*
* 系统消息列表
*/
class SystemMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SystemMessage();
  }
}

class SystemMessage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SystemMessageState();
  }
}

class SystemMessageState extends MessageState<SystemMessage>
    with WidgetsBindingObserver {
  Operation _operation = new Operation();
  int itemCount = 0;
  List<MessageEntity> _list;
  AppLifecycleState currentState = AppLifecycleState.resumed;
  Timer _refreshTimer;
  bool _dis;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataBaseControl.setCurrentPageName('SystemMessagePage');
    WidgetsBinding.instance.addObserver(this);
    _dis = false;
    _getData();
    _startRefresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (null != _refreshTimer) {
      _refreshTimer.cancel();
    }
    _dis = true;
    super.dispose();
    DataBaseControl.removeCurrentPageName('SystemMessagePage');
    WidgetsBinding.instance.removeObserver(this);
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
    //可以使用以下
//    // 如果APP不在在前台
//    if (currentState == AppLifecycleState.inactive) {
//
//    } else if (currentState == AppLifecycleState.resumed) {
//      // 在前台
//    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    //initState后，未调用，所以初始化为resume，当APP进入后台，则为onPause；APP进入前台，为resume
    currentState = state;
  }

  _getData() {
    MessageDataBase.get()
        .getMessageEntityInType(Constants.MESSAGE_TYPE_SYSTEM)
        .then((list) {
      setState(() {
        itemCount = list.length;
        _list = list;
      });
    });
    MessageDataBase.get()
        .updateAllMessageTypeEntity(Constants.MESSAGE_TYPE_SYSTEM_ZH)
        .then((res) {
      //标记所有系统消息为已读
      InteractNative.getMessageEventSink().add(ObjectUtil.getDefaultData(
          InteractNative.SYSTEM_MESSAGE_HAS_READ,
          Constants.MESSAGE_TYPE_SYSTEM_ZH));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            primarySwatch: ObjectUtil.getThemeSwatchColor(),
            platform: TargetPlatform.iOS),
        home: LoadingScaffold(
          operation: _operation,
          child: Scaffold(
            body: itemCount > 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _itemWidget(context, index);
                    },
                    itemCount: itemCount)
                : MoreWidgets.buildNoDataPage(),
            appBar: MoreWidgets.buildAppBar(
              context,
              Constants.MESSAGE_TYPE_SYSTEM_ZH,
              centerTitle: true,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                itemCount > 0
                    ? InkWell(
                        child: Container(
                            padding: EdgeInsets.only(right: 15, left: 15),
                            child: Icon(
                              Icons.delete,
                              size: 22,
                            )),
                        onTap: () {
                          DialogUtil.showBaseDialog(context, '确认全部删除？',
                              rightClick: (res) {
                            _deleteAll();
                          });
                        })
                    : Text(''),
              ],
            ),
          ),
        ));
  }

  Widget _itemWidget(BuildContext context, int index) {
    if (null == _list) {
      return Text('');
    } else if (_list.length <= index) {
      return Text('');
    }
    MessageEntity entity = _list.elementAt(index);
    if (entity == null) {
      return Text('');
    }
    String title;
    String content;
    String note;
    String statusText;
    int status = -1;
    bool showStatusBar;
    if (entity.status == 'untreated') {
      status = 0;
    } else if (entity.status == 'refused') {
      status = 1;
      statusText = '已拒绝';
    } else if (entity.status == 'agreed') {
      status = 1;
      statusText = '已同意';
    }
    if (entity.method == DataBaseControl.payload_contact_invited) {
      title = '好友邀请';
      content = '用户${entity.senderAccount}请求添加您为好友';
      showStatusBar = true;
      note = '消息验证：${entity.note}';
    } else if (entity.method == DataBaseControl.payload_contact_request) {
      title = '添加邀请被拒绝';
      content = '用户${entity.senderAccount}拒绝您的好友添加邀请！';
      showStatusBar = true;
    } else if (entity.method == DataBaseControl.payload_contact_accepted) {
      title = '添加邀请已同意';
      content = '用户${entity.senderAccount}同意您的好友添加邀请！';
      showStatusBar = true;
    }
    return new Dismissible(
      //如果Dismissible是一个列表项 它必须有一个key 用来区别其他项
      key: new Key(_list.elementAt(index).id.toString()),
      //在child被取消时调用
      onDismissed: (direction) {
        MessageDataBase.get()
            .deleteMessageEntity(entity.type, entity: entity)
            .then((res) {
          _list.removeAt(index);
          if (_list.length == 0) {
            MessageDataBase.get()
                .deleteMessageTypeEntity(
                    entity: MessageTypeEntity(
                        senderAccount: Constants.MESSAGE_TYPE_SYSTEM_ZH))
                .then((value) {
              setState(() {
                itemCount = 0;
                InteractNative.getMessageEventSink().add(
                    ObjectUtil.getDefaultData(
                        InteractNative.SYSTEM_MESSAGE_DELETE_ALL,
                        entity.senderAccount));
              });
            });
          } else {
            setState(() {
              itemCount = _list.length;
              InteractNative.getMessageEventSink().add(
                  ObjectUtil.getDefaultData(
                      InteractNative.SYSTEM_MESSAGE_DELETE,
                      entity.senderAccount));
            });
          }
        });
      },
      //如果指定了background 他将会堆叠在Dismissible child后面 并在child移除时暴露
      background: new Container(
        color: ObjectUtil.getThemeSwatchColor(),
        alignment: Alignment.center,
        child: Text(
          '侧滑删除',
          style:
              TextStyle(letterSpacing: 3, fontSize: 18.0, color: Colors.white),
        ),
      ),
      child: MoreWidgets.systemMessageListViewItem(
          title, content, TimelineUtil.format(int.parse(entity.time)),
          context: context,
          showStatusBar: showStatusBar,
          note: note,
          statusText: statusText,
          status: status, left: (res) {
        if (status == 0) {
          _friendsRefused(entity, index);
        }
      }, right: (res) {
        if (status == 0) {
          _friendsAgree(entity, index);
        }
      }),
    );
  }

  void _friendsAgree(MessageEntity user, int index) {
    _operation.setShowLoading(true);
    Map<String, String> map = {"username": user.senderAccount};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['acceptedFriends'], map)
        .then((success) {
      _operation.setShowLoading(false);
      if (success == true) {
        user.status = 'agreed';
        MessageDataBase.get()
            .deleteMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, entity: user)
            .then((res) {
          MessageDataBase.get()
              .updateMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, user)
              .then((res) {
            setState(() {
              _list.insert(index, user);
            });
          });
        });
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('请求失败');
      }
    });
  }

  void _friendsRefused(MessageEntity user, int index) {
    _operation.setShowLoading(true);
    Map<String, String> map = {"username": user.senderAccount};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['refusedFriends'], map)
        .then((success) {
      _operation.setShowLoading(false);
      if (success == true) {
        user.status = 'refused';
        MessageDataBase.get()
            .deleteMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, entity: user)
            .then((res) {
          MessageDataBase.get()
              .updateMessageEntity(Constants.MESSAGE_TYPE_SYSTEM, user)
              .then((res) {
            setState(() {
              _list.insert(index, user);
            });
          });
        });
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('请求失败');
      }
    });
  }

  Future _deleteAll() async {
    MessageDataBase.get()
        .deleteMessageTypeEntity(
            entity: MessageTypeEntity(
                senderAccount: Constants.MESSAGE_TYPE_SYSTEM_ZH))
        .then((value) {
      MessageDataBase.get()
          .deleteMessageEntity(Constants.MESSAGE_TYPE_SYSTEM)
          .then((res) {
        setState(() {
          itemCount = 0;
          InteractNative.getMessageEventSink().add(ObjectUtil.getDefaultData(
              InteractNative.SYSTEM_MESSAGE_DELETE_ALL,
              Constants.MESSAGE_TYPE_SYSTEM_ZH));
        });
      });
    });
  }

  @override
  void updateData(MessageEntity entity) {
    if (_dis) {
      return;
    }
    // TODO: implement updateData
    if (null != entity) {
      if (entity.type == Constants.MESSAGE_TYPE_SYSTEM) {
        _getData();
      }
    }
  }
}
