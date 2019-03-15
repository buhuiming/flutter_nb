import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/config.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/base/web_view_page.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
* 关于页面
*/
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new About();
  }
}

class About extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AboutState();
  }
}

class _AboutState extends State<About> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            platform: TargetPlatform.iOS),
        home: new Scaffold(
          key: _key,
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(
              child: ListView(
            children: <Widget>[
              SizedBox(height: 40.0),
              new Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: new Image.asset(
                      FileUtil.getImagePath('logo',
                          dir: 'splash', format: 'png'),
                      height: 120.0,
                      width: 120.0),
                ),
              ),
              SizedBox(height: 10),
              new Center(
                  child: Text(
                '版本号  ' + Config.VERSION,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15.0, color: ObjectUtil.getThemeColor()),
              )),
              SizedBox(height: 66.0),
              MoreWidgets.defaultListViewItem(null, 'github',
                  textColor: Colors.black, onItemClick: (res) {
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => new WebViewPage(
                              title: 'Github',
                              url: Constants.GITHUB_URL,
                            )));
              }),
              MoreWidgets.defaultListViewItem(null, '简书',
                  textColor: Colors.black, onItemClick: (res) {
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => new WebViewPage(
                              title: 'Github',
                              url: Constants.JIANSHU_URL,
                            )));
              }),
              MoreWidgets.defaultListViewItem(null, '版本更新',
                  textColor: Colors.black, onItemClick: (res) {
                DialogUtil.buildSnakeBarByKey('已经是最新版本', _key);
              }),
              MoreWidgets.defaultListViewItem(null, '其他',
                  textColor: Colors.black, onItemClick: (res) {
                DialogUtil.buildSnakeBarByKey('暂时没有了', _key);
              }),
            ],
          )),
          appBar: MoreWidgets.buildAppBar(
            context,
            '关于',
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
