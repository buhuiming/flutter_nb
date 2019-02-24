import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
*  我的
*/
class MinePage extends StatefulWidget {
  MinePage({Key key, this.title, this.operation, this.rootContext})
      : super(key: key);
  final String title;
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MineState();
  }
}

class _MineState extends State<MinePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(context, '',
            elevation: 0.0, height: 56, actions: _actions(context)),
        body: ListView(
          children: <Widget>[
            MoreWidgets.mineListViewItem1(
              FileUtil.getImagePath('logo', dir: 'splash', format: 'png'),
              SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT),
              content: '萍水相逢，尽是他乡之客',
            ),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.add_shopping_cart, '支付',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.favorite, '收藏',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.photo, '相册',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.content_copy, '卡包',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.face, '表情',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.settings, '设置',
                textColor: Colors.black, isDivider: false),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.exit_to_app, '退出',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              _logOut();
            }),
            MoreWidgets.buildDivider(),
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  List<Widget> _actions(BuildContext context) {
    List<Widget> actions = new List();
    Widget widget = InkWell(
        child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(
              Icons.add_a_photo,
              size: 22,
            )),
        onTap: () {
          DialogUtil.buildSnakeBar(context, '想拍照吗');
        });
    actions.add(widget);
    return actions;
  }

  _logOut() {
    widget.operation.setShowLoading(true);
    InteractNative.goNativeWithValue(InteractNative.methodNames['logout'])
        .then((success) {
      widget.operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('登出成功');
        SPUtil.putBool(Constants.KEY_LOGIN, false);
        Navigator.of(widget.rootContext).pushReplacementNamed('/LoginPage');
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('登出失败');
      }
    });
  }
}
