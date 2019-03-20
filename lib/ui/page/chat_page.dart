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
import 'package:keyboard_visibility/keyboard_visibility.dart';

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
  bool _isShowSend = false; //是否显示发送按钮
  bool _isShowVoice = false; //是否显示语音输入栏
  bool _isShowFace = false; //是否显示表情栏
  bool _isShowTools = false; //是否显示工具栏
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFieldNode = FocusNode();
  var voiceText = '按住 说话';
  var voiceBackground = ObjectUtil.getThemeLightColor();
  Color _headsetColor = ColorT.gray_99;
  Color _highlightColor = ColorT.gray_99;

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
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _isShowTools = false;
          _isShowFace = false;
          _isShowVoice = false;
        }
      },
    );
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
                          icon: _isShowVoice
                              ? Icon(Icons.keyboard)
                              : Icon(Icons.play_circle_outline),
                          iconSize: 32,
                          onPressed: () {
                            setState(() {
                              if (_isShowVoice) {
                                _isShowVoice = false;
                              } else {
                                _hideKeyBoard();
                                _isShowVoice = true;
                                _isShowFace = false;
                                _isShowTools = false;
                              }
                            });
                          }),
                      new Flexible(child: _enterWidget()),
                      IconButton(
                          icon: _isShowFace
                              ? Icon(Icons.keyboard)
                              : Icon(Icons.sentiment_very_satisfied),
                          iconSize: 32,
                          onPressed: () {
                            setState(() {
                              if (_isShowFace) {
                                _isShowFace = false;
                              } else {
                                _hideKeyBoard();
                                _isShowFace = true;
                                _isShowVoice = false;
                                _isShowTools = false;
                              }
                            });
                          }),
                      _isShowSend
                          ? InkWell(
                              onTap: () {
                                _sendMessage();
                              },
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
                              onPressed: () {
                                setState(() {
                                  if (_isShowTools) {
                                    _isShowTools = false;
                                  } else {
                                    _hideKeyBoard();
                                    _isShowTools = true;
                                    _isShowFace = false;
                                    _isShowVoice = false;
                                  }
                                });
                              }),
                    ],
                  ),
                ),
              ),
              (_isShowTools || _isShowFace || _isShowVoice)
                  ? Container(
                      height: 200,
                      child: _bottomWidget(),
                    )
                  : SizedBox(
                      height: 0,
                    )
            ])));
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

  _bottomWidget() {
    Widget widget;
    if (_isShowTools) {
      widget = _voiceWidget();
    } else if (_isShowFace) {
      widget = _voiceWidget();
    } else if (_isShowVoice) {
      widget = _voiceWidget();
    }
    return widget;
  }

  _voiceWidget() {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.headset,
                  color: _headsetColor,
                  size: 50,
                ))),
        Align(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  onScaleStart: (res) {
                    setState(() {
                      voiceText = '松开 结束';
                      voiceBackground = ColorT.divider;
                    });
                  },
                  onScaleEnd: (res) {
                    if(_headsetColor == ObjectUtil.getThemeLightColor()){
                      DialogUtil.buildToast('试听功能暂未实现');
                    }else if(_highlightColor == ObjectUtil.getThemeLightColor()){
                      DialogUtil.buildToast('删除功能暂未实现');
                    }else{
                      DialogUtil.buildToast('发送语音');
                    }
                    setState(() {
                      voiceText = '按住 说话';
                      voiceBackground = ObjectUtil.getThemeLightColor();
                      _headsetColor = ColorT.gray_99;
                      _highlightColor = ColorT.gray_99;
                    });
                  },
                  onScaleUpdate: (res) {
                    print(res.toString());
                    if (res.focalPoint.dy > 560 && res.focalPoint.dy < 590) {
                      if (res.focalPoint.dx > 10 && res.focalPoint.dx < 80) {
                        setState(() {
                          voiceText = '松开 试听';
                          _headsetColor = ObjectUtil.getThemeLightColor();
                        });
                      } else if (res.focalPoint.dx > 330 &&
                          res.focalPoint.dx < 390) {
                        setState(() {
                          voiceText = '松开 删除';
                          _highlightColor = ObjectUtil.getThemeLightColor();
                        });
                      } else {
                        setState(() {
                          voiceText = '松开 结束';
                          _headsetColor = ColorT.gray_99;
                          _highlightColor = ColorT.gray_99;
                        });
                      }
                    } else {
                      setState(() {
                        voiceText = '松开 结束';
                        _headsetColor = ColorT.gray_99;
                        _highlightColor = ColorT.gray_99;
                      });
                    }
                  },
                  child: new CircleAvatar(
                    child: new Text(
                      voiceText,
                      style:
                          new TextStyle(fontSize: 17.0, color: ColorT.gray_33),
                    ),
                    radius: 60,
                    backgroundColor: voiceBackground,
                  ),
                ))),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.highlight_off,
                  color: _highlightColor,
                  size: 50,
                ))),
      ],
    );
  }

  /*输入框*/
  _enterWidget() {
    return new Material(
      borderRadius: BorderRadius.circular(8.0),
      shadowColor: ObjectUtil.getThemeLightColor(),
      color: ColorT.gray_f0,
      elevation: 0,
      child: new TextField(
          focusNode: _textFieldNode,
          textInputAction: TextInputAction.send,
          controller: _controller,
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
          onEditingComplete: () {
            _sendMessage();
          }),
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

  _sendMessage() {
    if (_controller.text.isEmpty) {
      return;
    }
  }

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
  }
}
