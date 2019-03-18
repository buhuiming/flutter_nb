import 'package:flutter/material.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
*  发送聊天信息
*/
class ChatPage extends StatefulWidget {
  final String title;
  final String senderAccount;

  const ChatPage({Key key, @required this.title, @required this.senderAccount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatState();
  }
}

class ChatState extends MessageState<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBlackList();
  }

  _checkBlackList() {
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['getBlackListUsernames'], null)
        .then((blackList) {
      setState(() {
        if (null != blackList && blackList is List) {
          if (blackList.contains(widget.senderAccount)) {}
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
            widget.title,
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
                        Icons.delete,
                        size: 22,
                      )),
                  onTap: () {})
            ],
          ),
          body: ListView(),
        ));
  }

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
  }
}
