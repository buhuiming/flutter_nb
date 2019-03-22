import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';

/*
* 通知设置
*/
class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new NotificationSettings();
  }
}

class NotificationSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _NotificationSettingsState();
  }
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext buildContext) {
    // TODO: implement build
    return new MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            platform: TargetPlatform.iOS),
        home: new Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                MoreWidgets.switchListViewItem(null, '接收新消息通知',
                    value: SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) !=
                        false, onSwitch: (isCheck) {
                  setState(() {
                    print(isCheck);
                    SPUtil.putBool(Constants.NOTIFICATION_KEY_ALL, isCheck);
                  });
                }),
                SPUtil.getBool(Constants.NOTIFICATION_KEY_ALL) != false
                    ? Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  MoreWidgets.switchListViewItem(null, '系统消息通知',
                                      value: SPUtil.getBool(Constants
                                              .NOTIFICATION_KEY_SYSTEM) !=
                                          false, onSwitch: (isCheck) {
                                    setState(() {
                                      print(isCheck);
                                      SPUtil.putBool(
                                          Constants.NOTIFICATION_KEY_SYSTEM,
                                          isCheck);
                                    });
                                  }),
                                  MoreWidgets.switchListViewItem(null, '聊天消息通知',
                                      value: SPUtil.getBool(Constants
                                              .NOTIFICATION_KEY_CHAT) !=
                                          false, onSwitch: (isCheck) {
                                    setState(() {
                                      print(isCheck);
                                      SPUtil.putBool(
                                          Constants.NOTIFICATION_KEY_CHAT,
                                          isCheck);
                                    });
                                  }),
                                  MoreWidgets.switchListViewItem(null, '其他消息通知',
                                      value: SPUtil.getBool(Constants
                                              .NOTIFICATION_KEY_OTHERS) !=
                                          false, onSwitch: (isCheck) {
                                    setState(() {
                                      print(isCheck);
                                      SPUtil.putBool(
                                          Constants.NOTIFICATION_KEY_OTHERS,
                                          isCheck);
                                    });
                                  }),
                                ],
                              ))
                        ],
                      )
                    : Text('')
              ],
            ),
          ),
          appBar: MoreWidgets.buildAppBar(
            buildContext,
            '新消息提醒',
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
}
