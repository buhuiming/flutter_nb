import 'package:flutter/material.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';

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

class SystemMessageState extends MessageState<SystemMessage> {
  Operation _operation = new Operation();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingScaffold(
      operation: _operation,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            MoreWidgets.systemMessageListViewItem(
                "好友邀请", "用户15077501999请求添加您为好友", "10:20",
                note: '好友验证：加个好友呗，达到哈酒侃大山恐龙当家奥斯卡来得及奥斯卡的煎熬是考虑到静安寺恐龙当家阿拉丁'),
          ],
        ),
        appBar: MoreWidgets.buildAppBar(
          context,
          '系统消息',
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
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  @override
  void notify(String type, MessageEntity entity) {
    // TODO: implement notify
  }
}
