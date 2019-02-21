import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/functions.dart';

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
    return PreferredSize(
        child: AppBar(
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
              Expanded(
                //文本过长，打点
                flex: 1,
                child: Text(
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
            child: Divider(height: 1.5),
          )
        ]));
  }

  /*
  *  生成消息-ListView的item
  */
  static Widget messageListViewItem(String imageUrl, String text,
      {bool isNetImage = false,
      int unread = 0,
      String content = '',
      String time = '',
      double imageSize = 48.0,
      OnItemClick onItemClick,
      OnItemLongClick onItemLongClick}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {
          onItemLongClick(null);
        },
        child: Container(
            padding: EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 0),
            child: Column(children: <Widget>[
              //1列n行
              Row(
                children: <Widget>[
                  //1行3列
                  Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: <Widget>[
                              SizedBox(
                                width: imageSize + 5,
                                height: imageSize + 5,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: isNetImage
                                    ? Image.network(
                                        imageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                      )
                                    : Image.asset(imageUrl,
                                        width: imageSize, height: imageSize),
                              ),
                            ]),
                        unread > 0
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 10.0,
                                child: Text(
                                  unread.toString(),
                                  style: TextStyle(
                                      fontSize: unread > 99 ? 10.0 : 12.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Text(''),
                      ]),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17.0, color: ColorT.text_dark),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          content,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0, color: ColorT.text_gray),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.topRight,
                    child: Text(
                      time,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.0, color: ColorT.text_gray),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 65.0, top: 10),
                child: Divider(height: 1.5),
              )
            ])));
  }
}
