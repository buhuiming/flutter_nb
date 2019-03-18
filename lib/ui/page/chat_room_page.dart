import 'package:flutter/material.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/object_util.dart';
/*
* 聊天室
*/
class ChatRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatRoomState();
  }
}

class ChatRoomState extends MessageState<ChatRoomPage> {
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
            '',
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
