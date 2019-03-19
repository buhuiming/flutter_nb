import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
*  发送聊天信息
*/
class ChatPage extends StatefulWidget {
  final String title;
  final String senderAccount;
  final Operation operation;

  const ChatPage(
      {Key key,
        @required this.operation,
        @required this.title,
        @required this.senderAccount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatState();
  }
}

class ChatState extends MessageState<ChatPage> {
  bool _isBlackName = false;
  var _popString = List<String>();
  bool _isShowSend = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
    _checkBlackList();
  }

  _initData() {
    _popString.add('清空记录');
    _popString.add('删除好友');
    _popString.add('加入黑名单');
  }

  _checkBlackList() {
    InteractNative.goNativeWithValue(
        InteractNative.methodNames['getBlackListUsernames'], null)
        .then((blackList) {
      setState(() {
        if (null != blackList && blackList is List) {
          if (blackList.contains(widget.senderAccount)) {
            _isBlackName = true;
            _popString[2] = '移出黑名单';
          } else {
            _isBlackName = false;
            _popString[2] = '加入黑名单';
          }
        }
      });
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
        home: Scaffold(
            appBar: MoreWidgets.buildAppBar(
              context,
              _isBlackName ? widget.title + '(黑名单)' : widget.title,
              centerTitle: true,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                InkWell(
                    child: Container(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Icon(
                          Icons.more_horiz,
                          size: 22,
                        )),
                    onTap: () {
                      MoreWidgets.buildDefaultMessagePop(context, _popString,
                          onItemClick: (res) {
                            switch (res) {
                              case 'one':
                                DialogUtil.showBaseDialog(context, '即将删除该对话的全部聊天记录',
                                    right: '删除', left: '再想想', rightClick: (res) {});
                                break;
                              case 'two':
                                DialogUtil.showBaseDialog(context, '确定删除好友吗？',
                                    right: '删除', left: '再想想', rightClick: (res) {
                                      _deleteContact(widget.senderAccount);
                                    });
                                break;
                              case 'three':
                                if (_isBlackName) {
                                  DialogUtil.showBaseDialog(context, '确定把好友移出黑名单吗？',
                                      right: '移出', left: '再想想', rightClick: (res) {
                                        _removeUserFromBlackList(widget.senderAccount);
                                      });
                                } else {
                                  DialogUtil.showBaseDialog(context, '确定把好友加入黑名单吗？',
                                      right: '赶紧', left: '再想想', rightClick: (res) {
                                        DialogUtil.showBaseDialog(
                                            context, '即将将好友加入黑名单，是否需要支持发消息给TA？',
                                            right: '需要',
                                            left: '不需要',
                                            title: '', rightClick: (res) {
                                          _addToBlackList("1", widget.senderAccount);
                                        }, leftClick: (res) {
                                          _addToBlackList("0", widget.senderAccount);
                                        });
                                      });
                                }
                                break;
                            }
                          });
                    })
              ],
            ),
            body: new Column(children: <Widget>[
              new Flexible(child: new ListView()),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Container(
                  height: 54,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.play_circle_outline),
                          iconSize: 32,
                          onPressed: null),
                      new Flexible(
                        child: _enterWidget(),
                      ),
                      IconButton(
                          icon: Icon(Icons.sentiment_very_satisfied),
                          iconSize: 32,
                          onPressed: null),
                      _isShowSend
                          ? InkWell(
                        onTap: () {},
                        child: new Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 32,
                          margin: EdgeInsets.only(right: 8),
                          child: new Text(
                            '发送',
                            style: new TextStyle(
                                fontSize: 14.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                            color: ObjectUtil.getThemeSwatchColor(),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      )
                          : IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          iconSize: 32,
                          onPressed: null),
                    ],
                  ),
                ),
              )
            ])));
  }

  _enterWidget() {
    return new Material(
      borderRadius: BorderRadius.circular(8.0),
      shadowColor: ObjectUtil.getThemeLightColor(),
      color: ColorT.gray_f0,
      elevation: 0,
      child: new TextField(
//                            focusNode: firstTextFieldNode,
          textInputAction: TextInputAction.send,
//                            controller: _usernameController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(150), //长度限制11
          ], //只能输入整数
          style: TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
          ),
          onChanged: (str) {
            setState(() {
              if (str.isNotEmpty) {
                _isShowSend = true;
              } else {
                _isShowSend = false;
              }
            });
          },
          onEditingComplete: () => FocusScope.of(context)
//                                .requestFocus(secondTextFieldNode),
      ),
    );
  }

  /*删除好友*/
  _deleteContact(String username) {
    widget.operation.setShowLoading(true);
    Map<String, String> map = {"username": username};
    InteractNative.goNativeWithValue(
        InteractNative.methodNames['deleteContact'], map)
        .then((success) {
      widget.operation.setShowLoading(false);
      if (success == true) {
        Navigator.pop(context);
      } else {
        DialogUtil.buildToast('删除好友失败');
      }
    });
  }

  /*加入黑名单*/
  _addToBlackList(String isNeed, String username) {
    widget.operation.setShowLoading(true);
    Map<String, String> map = {"username": username, "isNeed": isNeed};
    InteractNative.goNativeWithValue(
        InteractNative.methodNames['addUserToBlackList'], map)
        .then((success) {
      if (success == true) {
        InteractNative.getMessageEventSink()
            .add(ObjectUtil.getDefaultData('updateBlackList'));
        _checkBlackList();
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
        InteractNative.getMessageEventSink()
            .add(ObjectUtil.getDefaultData('updateBlackList'));
        _checkBlackList();
      } else {
        DialogUtil.buildToast('移出黑名单失败');
      }
      widget.operation.setShowLoading(false);
    });
  }

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
  }
}
