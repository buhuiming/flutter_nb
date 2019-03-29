import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/object_util.dart';

class MoreWidgets {
  /*
  *  生成常用的AppBar
  */
  static Widget buildAppBar(BuildContext context, String text,
      {double fontSize: 18.0,
      double height: 50.0,
      double elevation: 0.5,
      Widget leading,
      bool centerTitle: false,
      List<Widget> actions,
      OnItemDoubleClick onItemDoubleClick}) {
    return PreferredSize(
        child: GestureDetector(
            onDoubleTap: () {
              if (null != onItemDoubleClick) {
                onItemDoubleClick(null);
              }
            },
            child: AppBar(
              elevation: elevation, //阴影
              centerTitle: centerTitle,
              title: Text(text, style: TextStyle(fontSize: fontSize)),
              leading: leading,
              actions: actions,
            )),
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
  static Widget messageListViewItem(
      String imageUrl, String text, String contentType,
      {bool isNetImage = false,
      int unread = 0,
      String content = '',
      String time = '',
      double imageSize = 48.0,
      OnItemClick onItemClick,
      OnItemLongClick onItemLongClick}) {
    if (contentType == Constants.CONTENT_TYPE_SYSTEM) {
      content = content.startsWith('assets/images/f') ? '[表情]' : content;
    } else if (contentType == Constants.CONTENT_TYPE_IMAGE) {
      content = '[图片]';
    } else if (contentType == Constants.CONTENT_TYPE_VOICE) {
      content = '[语音]';
    } else if (contentType == Constants.CONTENT_TYPE_VIDEO) {
      content = '[视频]';
    } else if (contentType == Constants.CONTENT_TYPE_LOCATION) {
      content = '[位置]';
    } else if (contentType == Constants.CONTENT_TYPE_FILE) {
      content = '[文件]';
    } else if (contentType == Constants.CONTENT_TYPE_CMD) {
      content = '[透传消息]';
    } else if (contentType == Constants.CONTENT_TYPE_DEFINED) {
      content = '[自定义消息]';
    }
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(text);
          }
        },
        onLongPress: () {
          onItemLongClick(text);
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
                                    : Image.asset(
                                        (imageUrl == '' || isNetImage == null)
                                            ? FileUtil.getImagePath(
                                                'img_headportrait',
                                                dir: 'icon',
                                                format: 'png')
                                            : imageUrl,
                                        width: imageSize,
                                        height: imageSize),
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

  /*
  *  生成我的-ListView的item
  */
  static Widget mineListViewItem1(String text,
      {int unread = 0,
      String content = '',
      String time = '',
      @required Widget imageChild,
      OnItemClick onItemClick,
      OnItemClick onImageClick}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {},
        child: Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 16, top: 20, bottom: 20),
            child: Column(children: <Widget>[
              //1列n行
              Row(
                children: <Widget>[
                  //1行3列
                  InkWell(
                      onTap: () {
                        if (onImageClick != null) {
                          onImageClick(null);
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: imageChild)),
                  SizedBox(
                    width: 20.0,
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
                              fontSize: 22.0, color: themeColorMap['black']),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          content,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0, color: ColorT.text_normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: ColorT.text_gray,
                      size: 18,
                    ),
                  )
                ],
              ),
            ])));
  }

  /*
  *  生成一个分割线
  */
  static Widget buildDivider({
    double height = 10,
    Color bgColor = ColorT.divider,
    double dividerHeight = 0.5,
    Color dividerColor = ColorT.divider,
  }) {
    BorderSide side = BorderSide(
        color: dividerColor, width: dividerHeight, style: BorderStyle.solid);
    return new Container(
        padding: EdgeInsets.all(height / 2),
        decoration: new BoxDecoration(
          color: bgColor,
          border: Border(top: side, bottom: side),
        ));
  }

  /*
  *  生成我的-ListView的item
  */
  static Widget defaultListViewItem(IconData iconData, String text,
      {double padding = 12.0,
      double imageSize = 20.0,
      bool isDivider = true,
      Color iconColor = ColorT.text_dark,
      Color textColor = ColorT.text_dark,
      OnItemClick onItemClick}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {},
        child: Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 0, top: padding, bottom: 0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  iconData == null
                      ? SizedBox(
                          width: 0.0,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Icon(
                            iconData,
                            size: imageSize,
                            color: iconColor,
                          ),
                        ),
                  SizedBox(
                    width: iconData == null ? 0 : 15.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.0, color: textColor),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: ColorT.text_gray,
                      size: 18,
                    ),
                  )
                ],
              ),
              isDivider
                  ? Container(
                      padding: EdgeInsets.only(
                          left: iconData == null ? 0 : 40.0, top: padding + 2),
                      child: Divider(
                        height: 1.5,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    )
            ])));
  }

  /*
  *  生成switch button-ListView的item
  */
  static Widget switchListViewItem(IconData iconData, String text,
      {double padding = 4.0,
      double imageSize = 16.0,
      bool isDivider = true,
      Color iconColor = ColorT.text_dark,
      Color textColor = ColorT.text_dark,
      OnItemClick onItemClick,
      OnItemClick onSwitch,
      bool value = true}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {},
        child: Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 0, top: padding, bottom: 0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  iconData == null
                      ? SizedBox(
                          width: 0.0,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Icon(
                            iconData,
                            size: imageSize,
                            color: iconColor,
                          ),
                        ),
                  SizedBox(
                    width: iconData == null ? 0 : 15.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.0, color: textColor),
                    ),
                  ),
                  Switch(
                      value: value,
                      activeColor: ObjectUtil.getThemeColor(), //激活时原点的颜色。
                      activeTrackColor:
                          ObjectUtil.getThemeLightColor(), //激活时横条的颜色。
                      onChanged: (isCheck) {
                        if (null != onSwitch) {
                          onSwitch(isCheck);
                        }
                      })
                ],
              ),
              isDivider
                  ? Container(
                      padding: EdgeInsets.only(
                          left: iconData == null ? 0 : 40.0, top: padding + 2),
                      child: Divider(
                        height: 1.5,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    )
            ])));
  }

  /*
  *  生成系统消息列表-ListView的item
  */
  static Widget systemMessageListViewItem(
    String title,
    String content,
    String time, {
    bool showStatusBar = false,
    int status = 0, //0:显示拒绝和同意，1：显示已同意/已拒绝
    String statusText = '已同意',
    OnItemClick left,
    OnItemClick right,
    BuildContext context,
    String note = '',
  }) {
    return InkWell(
        onTap: () {},
        onLongPress: () {},
        child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 0),
            child: Column(children: <Widget>[
              //1列n行
              Row(
                children: <Widget>[
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0, color: ColorT.text_dark),
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
                        SizedBox(
                          height: ObjectUtil.isEmpty(note) ? 0 : 3.0,
                        ),
                        ObjectUtil.isEmpty(note)
                            ? SizedBox(
                                width: 0,
                                height: 0,
                              )
                            : InkWell(
                                onTap: () {
                                  DialogUtil.showBaseDialog(context, note,
                                      title: '', left: '', right: '');
                                },
                                child: Text(note,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      color: ObjectUtil.getThemeColor(),
                                    ))),
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
              SizedBox(
                height: showStatusBar ? 10.0 : 0,
              ),
              showStatusBar
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(flex: 8, child: Text('')),
                        Expanded(
                            flex: 4,
                            child: status != 0
                                ? SizedBox(
                                    width: 0,
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (null != left) {
                                        left(0);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                      decoration: new BoxDecoration(
                                          color:
                                              ObjectUtil.getThemeLightColor(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          border: new Border.all(
                                              width: 0.5,
                                              color:
                                                  ObjectUtil.getThemeColor())),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '拒绝',
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            letterSpacing: 3,
                                            fontSize: 16.0,
                                            color: ObjectUtil.getThemeColor()),
                                      ),
                                    ),
                                  )),
                        Expanded(flex: 1, child: Text('')),
                        Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () {
                                if (null != left) {
                                  right(1);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                decoration: new BoxDecoration(
                                    color: ObjectUtil.getThemeLightColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    border: new Border.all(
                                        width: 0.5,
                                        color: ObjectUtil.getThemeColor())),
                                alignment: Alignment.center,
                                child: Text(
                                  status != 0 ? statusText : '同意',
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 16.0,
                                      color: ObjectUtil.getThemeColor()),
                                ),
                              ),
                            )),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                padding: EdgeInsets.only(left: 0.0, top: 13),
                child: Divider(
                  height: 1.5,
                ),
              )
            ])));
  }

  static Widget buildNoDataPage() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {},
        child: Text('没有数据',
            maxLines: 1,
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black54,
                letterSpacing: 0.6,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none)),
      ),
    );
  }

  /*
  * 消息列表，item长按弹出popupWindow
  */
  static Future buildMessagePop(BuildContext context, List<String> texts,
      {OnItemClick onItemClick}) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(130.0, 210.0, 130.0, 100.0),
        items: <PopupMenuItem<String>>[
          new PopupMenuItem<String>(
            value: 'one',
            child: Text(texts[0],
                style: new TextStyle(fontSize: 16.0, color: ColorT.app_main)),
          ),
          new PopupMenuItem<String>(
            value: 'two',
            child: Text(texts[1],
                style: new TextStyle(fontSize: 16.0, color: ColorT.app_main)),
          ),
          new PopupMenuItem<String>(
            value: 'three',
            child: Text(texts[2],
                maxLines: 1,
                style: new TextStyle(
                    fontSize: 16.0, color: ObjectUtil.getThemeSwatchColor())),
          ),
        ]).then((res) {
      if (null != onItemClick) {
        onItemClick(res);
      }
    });
  }

  /*
  * 右上角item长按弹出popupWindow
  */
  static Future buildDefaultMessagePop(BuildContext context, List<String> texts,
      {OnItemClick onItemClick}) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(double.infinity, 76, 0, 0),
        items: <PopupMenuItem<String>>[
          new PopupMenuItem<String>(
            value: 'one',
            child: Text(texts[0],
                style: new TextStyle(fontSize: 16.0, color: ColorT.app_main)),
          ),
          new PopupMenuItem<String>(
            value: 'two',
            child: Text(texts[1],
                style: new TextStyle(fontSize: 16.0, color: ColorT.app_main)),
          ),
          new PopupMenuItem<String>(
            value: 'three',
            child: Text(texts[2],
                maxLines: 1,
                style: new TextStyle(
                    fontSize: 16.0, color: ObjectUtil.getThemeSwatchColor())),
          ),
        ]).then((res) {
      if (null != onItemClick) {
        onItemClick(res);
      }
    });
  }

  /*
  *  聊天页面-工具栏item
  */
  static Widget buildIcon(IconData icon, String text, {OnItemClick o}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () {
              if (null != o) {
                o(null);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 54,
                height: 54,
                color: ObjectUtil.getThemeLightColor(),
                child: Icon(icon, size: 28),
              ),
            )),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
