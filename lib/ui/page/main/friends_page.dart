import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/page/base/search_page.dart';
import 'package:flutter_nb/ui/page/chat_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';

/*
*  朋友
*/
class FriendsPage extends StatefulWidget {
  FriendsPage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Friends();
  }
}

class Friends extends MessageState<FriendsPage>
    with AutomaticKeepAliveClientMixin {
  var _list = List();
  var _blackList = List();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setDefault();
    _getFriends();
  }

  _setDefault() {
    _list.add('新的朋友');
    _list.add('群聊');
    _list.add('收藏');
    _list.add('公众号');
  }

  _getFriends() {
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['getAllContacts'], null)
        .then((success) {
      if (null != success && success is List) {
        InteractNative.goNativeWithValue(
                InteractNative.methodNames['getBlackListUsernames'], null)
            .then((blackList) {
          setState(() {
            for (String ms in success) {
              if (!_list.contains(ms)) {
                _list.add(ms);
              }
            }
            if (null != blackList && blackList is List) {
              _blackList.clear();
              for (String ms in blackList) {
                if (!_blackList.contains(ms)) {
                  _blackList.add(ms);
                }
              }
            }
          });
        });
      }
    });
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: MoreWidgets.buildAppBar(context, '朋友'),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(index);
          },
          itemCount: _list.length),
    );
  }

  Widget _itemWidget(int index) {
    bool isBlackName = false;
    var _popString = List<String>();
    _popString.add('修改备注');
    _popString.add('删除好友');
    _popString.add('加入黑名单');
    if (_blackList.contains(_list[index])) {
      _popString[2] = '移出黑名单';
      isBlackName = true;
    } else {
      _popString[2] = '加入黑名单';
      isBlackName = false;
    }

    switch (index) {
      case 0:
        return InkWell(
          //点击带波纹的控件
          onTap: () {
            Navigator.push(
                context,
                new CupertinoPageRoute<void>(
                    builder: (ctx) =>
                        SearchPage(Constants.FUNCTION_SEARCH_FRIENDS)));
          },
          child: MoreWidgets.buildListViewItem('logo', _list[index],
              dir: 'splash'),
        );
      case 1:
        return InkWell(
          onTap: () {},
          child: MoreWidgets.buildListViewItem('group_chat', _list[index]),
        );
      case 2:
        return InkWell(
          onTap: () {},
          child: MoreWidgets.buildListViewItem('collection', _list[index]),
        );
      case 3:
        return InkWell(
          onTap: () {},
          child:
              MoreWidgets.buildListViewItem('official_accounts', _list[index]),
        );
      default:
        return InkWell(
          onTap: () {
            //聊天消息，跳转聊天对话页面
            Navigator.push(
                context,
                new CupertinoPageRoute<void>(
                    builder: (ctx) => ChatPage(
                          operation: widget.operation,
                          title: _list[index],
                          senderAccount: _list[index],
                        )));
          },
          onLongPress: () {
            MoreWidgets.buildMessagePop(context, _popString,
                onItemClick: (res) {
              switch (res) {
                case 'one':
                  DialogUtil.buildSnakeBarByKey('修改备注功能未实现', _key);
                  break;
                case 'two':
                  DialogUtil.showBaseDialog(context, '确定删除好友吗？',
                      right: '删除', left: '再想想', rightClick: (res) {
                    _deleteContact(_list[index]);
                  });
                  break;
                case 'three':
                  if (isBlackName) {
                    DialogUtil.showBaseDialog(context, '确定把好友移出黑名单吗？',
                        right: '移出', left: '再想想', rightClick: (res) {
                      _removeUserFromBlackList(_list[index]);
                    });
                  } else {
                    DialogUtil.showBaseDialog(context, '确定把好友加入黑名单吗？',
                        right: '赶紧', left: '再想想', rightClick: (res) {
                      DialogUtil.showBaseDialog(
                          context, '即将将好友加入黑名单，是否需要支持发消息给TA？',
                          right: '需要',
                          left: '不需要',
                          title: '', rightClick: (res) {
                        _addToBlackList("1", _list[index]);
                      }, leftClick: (res) {
                        _addToBlackList("0", _list[index]);
                      });
                    });
                  }
                  break;
              }
            });
          },
          child: MoreWidgets.buildListViewItem('img_headportrait',
              isBlackName ? (_list[index] + '(黑名单)') : _list[index]),
        );
    }
  }

  /*加入黑名单*/
  _addToBlackList(String isNeed, String username) {
    widget.operation.setShowLoading(true);
    Map<String, String> map = {"username": username, "isNeed": isNeed};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['addUserToBlackList'], map)
        .then((success) {
      if (success == true) {
        _getFriends();
      } else {
        DialogUtil.buildToast('加入黑名单失败');
      }
      widget.operation.setShowLoading(false);
    });
  }

  /*移出黑名单*/
  _removeUserFromBlackList(String username) {
    widget.operation.setShowLoading(true);
    Map<String, String> map = {"username": username};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['removeUserFromBlackList'], map)
        .then((success) {
      if (success == true) {
        _getFriends();
      } else {
        DialogUtil.buildToast('移出黑名单失败');
      }
      widget.operation.setShowLoading(false);
    });
  }

  /*删除好友*/
  _deleteContact(String username) {
    widget.operation.setShowLoading(true);
    Map<String, String> map = {"username": username};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['deleteContact'], map)
        .then((success) {
      if (success == true) {
        _getFriends();
      } else {
        DialogUtil.buildToast('删除好友失败');
      }
      widget.operation.setShowLoading(false);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
    if (entity != null &&
        entity.type == Constants.MESSAGE_TYPE_CHAT &&
        (entity.method == DataBaseControl.payload_contact_contactAdded ||
            entity.method ==
                DataBaseControl.payload_contact_contactDeleted)) {
      //如果收到的推送消息是聊天消息，并且属于好友增加、好友删除，则属性好友列表
      print('获取朋友列表');
      _list.remove(entity.senderAccount);
      _getFriends();
    } else if (entity != null && entity.type == 'updateBlackList') {
      _getFriends();
    }
  }
}
