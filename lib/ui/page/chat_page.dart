import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/chat_item_widgets.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
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
  List<Widget> _guideFaceList = new List();
  List<Widget> _guideFigureList = new List();
  List<Widget> _guideToolsList = new List();
  bool _isFaceFirstList = true;
  List<MessageEntity> _messageList = new List();
  bool _isLoadAll = false; //是否已经加载完本地数据
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataBaseControl.setCurrentPageName('ChatPage',
        chatName: widget.title);
    _getLocalMessage();
    _initData();
    _checkBlackList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DataBaseControl.removeCurrentPageName('ChatPage',
        chatName: widget.title);
  }

  _getLocalMessage() async {
    await MessageDataBase.get()
        .getMessageEntityInTypeLimit(widget.senderAccount,
            offset: _messageList.length, count: 20)
        .then((listEntity) async {
      if (null == listEntity || listEntity.length < 1) {
        _isLoadAll = true;
      } else {
        _isLoadAll = false;
      }
      for (MessageEntity entity in listEntity) {
        _messageList.insert(0, entity);
      }
      setState(() {});
    });
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

  _initFaceList() {
    if (_guideFaceList.length > 0) {
      _guideFaceList.clear();
    }
    if (_guideFigureList.length > 0) {
      _guideFigureList.clear();
    }
    //添加表情图
    List<String> _faceList = new List();
    String faceDeletePath =
        FileUtil.getImagePath('face_delete', dir: 'face', format: 'png');
    String facePath;
    for (int i = 0; i < 100; i++) {
      if (i < 90) {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'gif');
      } else {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'png');
      }
      _faceList.add(facePath);
      if (i == 19 || i == 39 || i == 59 || i == 79 || i == 99) {
        _faceList.add(faceDeletePath);
        _guideFaceList.add(_gridView(7, _faceList));
        _faceList.clear();
      }
    }
    //添加斗图
    List<String> _figureList = new List();
    for (int i = 0; i < 96; i++) {
      if (i == 70 || i == 74) {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'png');
        _figureList.add(facePath);
      } else {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'gif');
        _figureList.add(facePath);
      }
      if (i == 9 ||
          i == 19 ||
          i == 29 ||
          i == 39 ||
          i == 49 ||
          i == 59 ||
          i == 69 ||
          i == 79 ||
          i == 89 ||
          i == 95) {
        _guideFigureList.add(_gridView(5, _figureList));
        _figureList.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return MoreWidgets.buildAppBar(
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
    );
  }

  _body() {
    return Column(children: <Widget>[
      Flexible(
          child: InkWell(
        child: _messageListView(),
        onTap: () {
          setState(() {
            _hideKeyBoard();
            _isShowVoice = false;
            _isShowFace = false;
            _isShowTools = false;
          });
        },
      )),
      Divider(height: 1.0),
      Container(
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
                        _sendTextMessage();
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
              height: 220,
              child: _bottomWidget(),
            )
          : SizedBox(
              height: 0,
            )
    ]);
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

  _bottomWidget() {
    Widget widget;
    if (_isShowTools) {
      widget = _toolsWidget();
    } else if (_isShowFace) {
      widget = _faceWidget();
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
                    if (_headsetColor == ObjectUtil.getThemeLightColor()) {
                      DialogUtil.buildToast('试听功能暂未实现');
                    } else if (_highlightColor ==
                        ObjectUtil.getThemeLightColor()) {
                      DialogUtil.buildToast('删除功能暂未实现');
                    } else {
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
                    if (res.focalPoint.dy > 550 && res.focalPoint.dy < 620) {
                      if (res.focalPoint.dx > 10 && res.focalPoint.dx < 80) {
                        setState(() {
                          voiceText = '松开 试听';
                          _headsetColor = ObjectUtil.getThemeLightColor();
                        });
                      } else if (res.focalPoint.dx > 330 &&
                          res.focalPoint.dx < 400) {
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

  _faceWidget() {
    _initFaceList();
    return Column(
      children: <Widget>[
        Flexible(
            child: Stack(
          children: <Widget>[
            Offstage(
              offstage: _isFaceFirstList,
              child: Swiper(
                  autoStart: false,
                  circular: false,
                  indicator: CircleSwiperIndicator(
                      radius: 3.0,
                      padding: EdgeInsets.only(top: 20.0),
                      itemColor: ColorT.gray_99,
                      itemActiveColor: ObjectUtil.getThemeSwatchColor()),
                  children: _guideFigureList),
            ),
            Offstage(
              offstage: !_isFaceFirstList,
              child: Swiper(
                  autoStart: false,
                  circular: false,
                  indicator: CircleSwiperIndicator(
                      radius: 3.0,
                      padding: EdgeInsets.only(top: 20.0),
                      itemColor: ColorT.gray_99,
                      itemActiveColor: ObjectUtil.getThemeSwatchColor()),
                  children: _guideFaceList),
            )
          ],
        )),
        SizedBox(
          height: 6,
        ),
        new Divider(height: 1.0),
        Container(
          height: 30,
          child: Row(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: InkWell(
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          color: _isFaceFirstList
                              ? ObjectUtil.getThemeSwatchColor()
                              : _headsetColor,
                          size: 24,
                        ),
                        onTap: () {
                          setState(() {
                            _isFaceFirstList = true;
                          });
                        },
                      ))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                        child: Icon(
                          Icons.favorite_border,
                          color: _isFaceFirstList
                              ? _headsetColor
                              : ObjectUtil.getThemeSwatchColor(),
                          size: 24,
                        ),
                        onTap: () {
                          setState(() {
                            _isFaceFirstList = false;
                          });
                        },
                      ))),
            ],
          ),
        )
      ],
    );
  }

  _toolsWidget() {
    if (_guideToolsList.length > 0) {
      _guideToolsList.clear();
    }
    List<Widget> _widgets = new List();
    _widgets.add(MoreWidgets.buildIcon(Icons.insert_photo, '相册'));
    _widgets.add(MoreWidgets.buildIcon(Icons.camera_alt, '拍摄'));
    _widgets.add(MoreWidgets.buildIcon(Icons.videocam, '视频通话'));
    _widgets.add(MoreWidgets.buildIcon(Icons.location_on, '位置'));
    _widgets.add(MoreWidgets.buildIcon(Icons.view_agenda, '红包'));
    _widgets.add(MoreWidgets.buildIcon(Icons.swap_horiz, '转账'));
    _widgets.add(MoreWidgets.buildIcon(Icons.mic, '语音输入'));
    _widgets.add(MoreWidgets.buildIcon(Icons.favorite, '我的收藏'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets));
    List<Widget> _widgets1 = new List();
    _widgets1.add(MoreWidgets.buildIcon(Icons.person, '名片'));
    _widgets1.add(MoreWidgets.buildIcon(Icons.folder, '文件'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets1));
    return Swiper(
        autoStart: false,
        circular: false,
        indicator: CircleSwiperIndicator(
            radius: 3.0,
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            itemColor: ColorT.gray_99,
            itemActiveColor: ObjectUtil.getThemeSwatchColor()),
        children: _guideToolsList);
  }

  _gridView(int crossAxisCount, List<String> list) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(0.0),
        children: list.map((String name) {
          return new IconButton(
              onPressed: () {
                if (name.contains('face_delete')) {
                  DialogUtil.buildToast('暂时不会把自定义表情显示在TextField，谁会的教我~');
                } else {
                  _sendFaceMessage();
                }
              },
              icon: Image.asset(name,
                  width: crossAxisCount == 5 ? 60 : 32,
                  height: crossAxisCount == 5 ? 60 : 32));
        }).toList());
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
            _sendTextMessage();
          }),
    );
  }

  _messageListView() {
    return Container(
        color: ColorT.gray_f0,
        child: RefreshIndicator(
            color: ObjectUtil.getThemeSwatchColor(),
            onRefresh: _onRefresh,
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _messageListViewItem(index);
                },
                controller: _scrollController,
                itemCount: _messageList.length)));
  }

  Future<Null> _onRefresh() async {
    await _getLocalMessage();
    if (_isLoadAll) {
      if (_messageList.length < 1) {
        DialogUtil.buildToast('没有历史消息');
      } else {
        DialogUtil.buildToast('已加载全部历史消息');
      }
    }
  }

  Widget _messageListViewItem(int index) {
    MessageEntity _lastEntity = index < 1 ? null : _messageList[index - 1];
    MessageEntity _entity = _messageList[index];
    print('----pixels--' + _scrollController.position.pixels.toString() +
        '----maxScrollExtent--' + _scrollController.position.maxScrollExtent.toString());
    return ChatItemWidgets.buildChatListItem(_lastEntity, _entity);
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

  _sendTextMessage() {
    if (_controller.text.isEmpty) {
      return;
    }
  }

  _sendFaceMessage() {}

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
  }
}
