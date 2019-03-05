import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/database/message_database.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
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

class SystemMessageState extends MessageState<SystemMessage> {
  Operation _operation = new Operation();
  int itemCount = 0;
  List<MessageEntity> _list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
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
  }

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
    int status = -1;
    bool showStatusBar;
    if (entity.contentType == DataBaseControl.payload_contact_invited) {
      title = '好友邀请';
      content = '用户${entity.senderAccount}请求添加您为好友';
      showStatusBar = true;
      note = '消息验证：${entity.note}';
      status = 0;
    }
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
          title, content, TimelineUtil.format(int.parse(entity.time)),
          context: context,
          showStatusBar: showStatusBar,
          note: note,
          status: status,
          left: (res) {
            if(status == 0){
              _friendsRefused(entity.senderAccount);
            }
          },
          right: (res) {
            if(status == 0){
              _friendsAgree(entity.senderAccount);
            }
          }),
    );
  }

  void _friendsAgree(String user){

  }
  void _friendsRefused(String user){

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
