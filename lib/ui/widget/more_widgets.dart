import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/file_util.dart';

class MoreWidgets {
  /*
  *  生成常用的AppBar
  */
  static Widget buildAppBar(BuildContext context, String text,
      {double fontSize: 18.0, double height: 46.0, double elevation: 0.5}) {
    return new PreferredSize(
        child: new AppBar(
            elevation: elevation, //阴影
            title: Text(text, style: TextStyle(fontSize: fontSize))),
        preferredSize: Size.fromHeight(height));
  }

  /*
  *  生成朋友-ListView的item
  */
  static Widget buildListViewItem(String fileName, String text,
      {String dir = 'icon', String format = 'png'}) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 0, top: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                    FileUtil.getImagePath(fileName, dir: dir, format: format),
                    width: 38.0,
                    height: 38.0),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(text,
                  style: TextStyle(fontSize: 17.0, color: ColorT.text_dark))
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 55.0),
            child: new Divider(),
          )
        ],
      ),
    );
  }
}
