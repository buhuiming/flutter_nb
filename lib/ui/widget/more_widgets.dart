import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/file_util.dart';

class MoreWidgets {
  /*
  *  生成常用的AppBar
  */
  static Widget buildAppBar(BuildContext context, String text,
      {double fontSize: 18.0,
      double height: 46.0,
      double elevation: 0.5,
      Widget leading,
      bool centerTitle: false}) {
    return new PreferredSize(
        child: new AppBar(
            elevation: elevation, //阴影
            centerTitle: centerTitle,
            title: Text(text, style: TextStyle(fontSize: fontSize)),
            leading: leading),
        preferredSize: Size.fromHeight(height));
  }

  /*
  *  生成朋友-ListView的item
  */
  static Widget buildListViewItem(String fileName, String text,
      {String dir = 'icon',
      String format = 'png',
      double padding = 8.0,
      double imageSize = 38.0}) {
    return Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16, top: padding, bottom: 0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                    FileUtil.getImagePath(fileName, dir: dir, format: format),
                    width: imageSize,
                    height: imageSize),
              ),
              SizedBox(
                width: 15.0,
              ),
              new Expanded(
                //文本过长，打点
                flex: 1,
                child: new Text(
                  text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17.0, color: ColorT.text_dark),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 55.0, top: padding),
            child: new Divider(height: 1.5),
          )
        ]));
  }
}
