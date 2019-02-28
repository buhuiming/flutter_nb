import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/setting_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/ui/widget/popupwindow_widget.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
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

class _MineState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  File imageChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(context, '',
            elevation: 0.0, actions: _actions(context)),
        body: ListView(
          children: <Widget>[
            MoreWidgets.mineListViewItem1(
                SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT),
                content: '萍水相逢，尽是他乡之客',
                imageChild: _getHeadPortrait(), onImageClick: (res) {
              PopupWindowUtil.showPhotoChosen(context, onCallBack: (image) {
                setState(() {
                  imageChild = image;
                });
              });
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.add_shopping_cart, '支付',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.favorite, '收藏',
                textColor: Colors.black),
            MoreWidgets.defaultListViewItem(Icons.photo, '相册',
                textColor: Colors.black, onItemClick: (res) {}),
            MoreWidgets.defaultListViewItem(Icons.content_copy, '卡包',
                textColor: Colors.black, onItemClick: (res) {}),
            MoreWidgets.defaultListViewItem(Icons.face, '表情',
                textColor: Colors.black, onItemClick: (res) {}),
            MoreWidgets.defaultListViewItem(Icons.settings, '设置',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              Navigator.push(
                  context,
                  new CupertinoPageRoute<void>(
                      builder: (ctx) => SettingPage()));
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.exit_to_app, '退出',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              DialogUtil.showBaseDialog(context, '确定退出登录吗？', rightClick: (res) {
                _logOut();
              });
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
          PopupWindowUtil.showPhotoChosen(context);
        });
    actions.add(widget);
    return actions;
  }

  Widget _getHeadPortrait() {
    if (null != imageChild) {
      return Image.file(imageChild, width: 62, height: 62, fit: BoxFit.fill);
    }
    return Image.asset(
        FileUtil.getImagePath('logo', dir: 'splash', format: 'png'),
        fit: BoxFit.fill,
        width: 62,
        height: 62);
  }

  _logOut() {
    widget.operation.setShowLoading(true);
    InteractNative.goNativeWithValue(InteractNative.methodNames['logout'])
        .then((success) {
      widget.operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('登出成功');
        ObjectUtil.doExit(widget.rootContext);
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('登出失败');
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
