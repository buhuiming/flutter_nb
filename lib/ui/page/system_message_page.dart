import 'package:flutter/material.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/object_util.dart';

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
  int itemCount = 0;

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
        body: itemCount > 0
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _itemWidget(context, index);
                },
                itemCount: itemCount)
            : MoreWidgets.buildNoDataPage(),
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
    );
  }

  Widget _itemWidget(BuildContext context, int index) {
    return new Dismissible(
      //如果Dismissible是一个列表项 它必须有一个key 用来区别其他项
      key: new Key(''),
      //在child被取消时调用
      onDismissed: (direction) {},
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
          "好友邀请", "用户15077501999请求添加您为好友", "10:20",
          context: context,
          showStatusBar: true,
          note: '验证消息：加个好友呗，达到哈酒侃大山恐龙当家奥斯卡来得及奥斯卡的煎熬是考虑到静安寺恐龙当家阿拉丁'),
    );
  }

  Future _deleteAll() async {
    setState(() {
      itemCount = 0;
    });
  }

  @override
  void notify(String type, MessageEntity entity) {
    // TODO: implement notify
  }
}
