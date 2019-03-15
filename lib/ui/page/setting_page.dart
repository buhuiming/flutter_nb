import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/about_page.dart';
import 'package:flutter_nb/ui/page/base/theme_state.dart';
import 'package:flutter_nb/ui/page/change_theme_page.dart';
import 'package:flutter_nb/ui/page/notification_settings_page.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
* 设置页面
*/
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Setting();
  }
}

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SettingState();
  }
}

class _SettingState extends ThemeState<Setting> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            platform: TargetPlatform.iOS),
        home: new Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(
              child: ListView(
            children: <Widget>[
              MoreWidgets.defaultListViewItem(null, '切换主题',
                  textColor: Colors.black, onItemClick: (res) {
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => ChangeThemePage()));
              }),
              MoreWidgets.defaultListViewItem(null, '清理缓存',
                  textColor: Colors.black, onItemClick: (res) {
                DialogUtil.buildToast('清理完成');
              }),
              MoreWidgets.defaultListViewItem(null, '新消息提醒',
                  textColor: Colors.black, onItemClick: (res) {
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => NotificationSettingsPage()));
              }),
              MoreWidgets.defaultListViewItem(null, '关于',
                  textColor: Colors.black, onItemClick: (res) {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute<void>(
                            builder: (ctx) => AboutPage()));
                  }),
            ],
          )),
          appBar: MoreWidgets.buildAppBar(
            context,
            '设置',
            centerTitle: true,
            elevation: 2.0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ));
  }

  @override
  void notify(Object type) {
    // TODO: implement notify
    setState(() {
      if (type == InteractNative.RESET_THEME_COLOR) {
        init();
      }
    });
  }
}
