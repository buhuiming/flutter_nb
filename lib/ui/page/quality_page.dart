import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class QualityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QualityPageState();
  }
}

class QualityPageState extends State<QualityPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Padding(
            child: Image.asset(
              'assets/images/splash/logo.png',
              width: 100,
              height: 100,
            ),
            padding: EdgeInsets.only(top: 100),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 50, bottom: 20),
            padding: EdgeInsets.only(left: 30, right: 30),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                '微信登录',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {},
            ),
          ),
          Container(
            height: 45,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: OutlineButton(
              borderSide: BorderSide(color: Colors.green),
              child: Text(
                '注册',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {},
            ),
          ),
          Container(
              //屏幕高度-状态栏高度-注册按钮底部的y坐标
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  360,
              alignment: Alignment.bottomCenter,
              padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20), //bottom可以改变
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '登录后表示同意 ',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    TextSpan(
                        text: '使用协议/隐私协议',
                        style: TextStyle(color: Colors.green, fontSize: 14))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /*Widget layout(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('干货'),
              background: Image.asset(
                FileUtil.getImagePath('img_fest', format: 'png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid(
              //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
          ),
          //List
          new SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              //创建列表项
              return new Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: new Text('list item $index'),
              );
            }, childCount: 50 //50个列表项
                ),
          ),
        ],
      ),
    );
  }*/
}
