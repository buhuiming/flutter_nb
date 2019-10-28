import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/date_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
* 对话页面中的widget
*/
class ChatItemWidgets {
  static Widget buildChatListItem(
      MessageEntity nextEntity, MessageEntity entity,
      {OnItemClick onResend, OnItemClick onItemClick}) {
    bool _isShowTime = true;
    var showTime; //最终显示的时间
    if (null == nextEntity) {
      _isShowTime = true;
    } else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((int.parse(entity.time) - int.parse(nextEntity.time)).abs() >
          3 * 60 * 1000) {
        _isShowTime = true;
      } else {
        _isShowTime = false;
      }
    }
    //获取当前的时间,yyyy-MM-dd HH:mm
    String nowTime = DateUtil.getDateStrByMs(
        new DateTime.now().millisecondsSinceEpoch,
        format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);
    //当前消息的时间,yyyy-MM-dd HH:mm
    String indexTime = DateUtil.getDateStrByMs(int.parse(entity.time),
        format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);

    if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR)) {
      //对比年份,不同年份，直接显示yyyy-MM-dd HH:mm
      showTime = indexTime;
    } else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      showTime =
          DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    } else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH_DAY) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH_DAY)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      showTime =
          DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    } else {
      //否则HH:mm
      showTime = DateUtil.formatDateTime1(indexTime, DateFormat.HOUR_MINUTE);
    }

    return Container(
      child: Column(
        children: <Widget>[
          _isShowTime
              ? Center(
                  heightFactor: 2,
                  child: Text(
                    showTime,
                    style: TextStyle(color: ColorT.transparent_50),
                  ))
              : SizedBox(height: 0),
          _chatItemWidget(entity, onResend, onItemClick)
        ],
      ),
    );
  }

  static Widget _chatItemWidget(
      MessageEntity entity, OnItemClick onResend, OnItemClick onItemClick) {
    if (entity.messageOwner == 1) {
      //对方的消息
      return Container(
        margin: EdgeInsets.only(left: 10, right: 90, bottom: 30, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headPortrait(entity.imageUrl, 1),
            SizedBox(width: 10),
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entity.senderAccount,
                  style: TextStyle(fontSize: 16, color: ColorT.gray_66),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: _contentWidget(entity),
                  onTap: () {
                    if (null != onItemClick) {
                      onItemClick(entity);
                    }
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                ),
              ],
            )),
          ],
        ),
      );
    } else {
      //自己的消息
      return Container(
        margin: EdgeInsets.only(left: 90, right: 10, bottom: 30, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '我',
                  style: TextStyle(fontSize: 14, color: ColorT.gray_66),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: _contentWidget(entity),
                  onTap: () {
                    if (null != onItemClick) {
                      onItemClick(entity);
                    }
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                ),
                //显示是否重发1、发送2中按钮，发送成功0或者null不显示
                entity.status == '1'
                    ? IconButton(
                        icon: Icon(Icons.refresh, color: Colors.red, size: 18),
                        onPressed: () {
                          if (null != onResend) {
                            onResend(entity);
                          }
                        })
                    : (entity.status == '2'
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 20, right: 20),
                            width: 32.0,
                            height: 32.0,
                            child: SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      ObjectUtil.getThemeSwatchColor()),
                                  strokeWidth: 2,
                                )),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          )),
              ],
            )),
            SizedBox(width: 10),
            _headPortrait(entity.imageUrl, 0),
          ],
        ),
      );
    }
  }

  /*
  *  头像
  */
  static Widget _headPortrait(String url, int owner) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: url.isEmpty
            ? Image.asset(
                (owner == 1
                    ? FileUtil.getImagePath('img_headportrait',
                        dir: 'icon', format: 'png')
                    : FileUtil.getImagePath('logo',
                        dir: 'splash', format: 'png')),
                width: 44,
                height: 44)
            : (ObjectUtil.isNetUri(url)
                ? Image.network(
                    url,
                    width: 44,
                    height: 44,
                    fit: BoxFit.fill,
                  )
                : Image.asset(url, width: 44, height: 44)));
  }

  /*
  *  内容
  */
  static Widget _contentWidget(MessageEntity entity) {
    Widget widget;
    if (entity.contentType == Constants.CONTENT_TYPE_SYSTEM ||
        entity.method == DataBaseControl.payload_contact_contactAdded) {
      //文本
      if (entity.content.contains('assets/images/face') ||
          entity.content.contains('assets/images/figure')) {
        widget = buildImageWidget(entity);
      } else {
        widget = buildTextWidget(entity);
      }
    } else if (entity.contentType == Constants.CONTENT_TYPE_IMAGE) {
      widget = buildImageWidget(entity);
    } else if (entity.contentType == Constants.CONTENT_TYPE_VOICE) {
      widget = buildVoiceWidget(entity);
    } else if (entity.contentType == Constants.CONTENT_TYPE_VIDEO) {
      widget = buildVideoWidget(entity);
    } else {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.all(10),
          color: ObjectUtil.getThemeLightColor(),
          child: Text(
            '未知消息类型',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      );
    }
    return widget;
  }

  static Widget buildTextWidget(MessageEntity entity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        color: entity.messageOwner == 1
            ? Colors.white
            : Color.fromARGB(255, 158, 234, 106),
        child: Text(
          entity.content,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  static Widget buildImageWidget(MessageEntity entity) {
    //图像
    double size = 120;
    Widget image;
    if (entity.contentUrl.isNotEmpty &&
        entity.contentUrl.contains('assets/images/face')) {
      //assets/images/face中的表情
      size = 32;
      image = Image.asset(entity.contentUrl, width: size, height: size);
    } else if (entity.contentUrl.isNotEmpty &&
        entity.contentUrl.contains('assets/images/figure')) {
      //assets/images/figure中的表情
      size = 90;
      image = Image.asset(entity.contentUrl, width: size, height: size);
    } else if (entity.contentUrl.isNotEmpty &&
        entity.contentUrl.contains('/storage/emulated/0')) {
      if (File(entity.contentUrl).existsSync()) {
        image = Image.file(
          File(entity.contentUrl),
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      } else {
        image = Image.asset(
          FileUtil.getImagePath('img_default', dir: 'default', format: 'png'),
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      }
    } else if (ObjectUtil.isNetUri(entity.contentUrl)) {
      image = Image.network(
        entity.contentUrl,
        width: size,
        height: size,
        fit: BoxFit.fill,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all((entity.contentUrl.isNotEmpty &&
                entity.contentUrl.contains('assets/images/face'))
            ? 10
            : 0),
        color: entity.messageOwner == 1
            ? Colors.white
            : Color.fromARGB(255, 158, 234, 106),
        child: image,
      ),
    );
  }

  static Widget buildVoiceWidget(MessageEntity entity) {
    double width;
    if (entity.length < 5000) {
      width = 90;
    } else if (entity.length < 10000) {
      width = 140;
    } else if (entity.length < 20000) {
      width = 180;
    } else {
      width = 200;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          width: width,
          color: entity.messageOwner == 1
              ? Colors.white
              : Color.fromARGB(255, 158, 234, 106),
          child: Row(
            mainAxisAlignment: entity.messageOwner == 1
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: <Widget>[
              entity.messageOwner == 1
                  ? Text('')
                  : Text((entity.length ~/ 1000).toString() + 's',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(
                width: 5,
              ),
              entity.isVoicePlaying == true
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 1, right: 1),
                      width: 18.0,
                      height: 18.0,
                      child: SizedBox(
                          width: 14.0,
                          height: 14.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                            strokeWidth: 2,
                          )),
                    )
                  : Image.asset(
                      FileUtil.getImagePath('audio_player_3',
                          dir: 'icon', format: 'png'),
                      width: 18,
                      height: 18,
                      color: Colors.black,
                    ),
              SizedBox(
                width: 5,
              ),
              entity.messageOwner == 1
                  ? Text((entity.length ~/ 1000).toString() + 's',
                      style: TextStyle(fontSize: 18, color: Colors.black))
                  : Text(''),
            ],
          )),
    );
  }

  static Widget buildVideoWidget(MessageEntity entity) {
    //视频
    double size = 120;
    Widget image;
    if (entity.thumbPath.isNotEmpty &&
        entity.thumbPath.contains('/storage/emulated/0')) {
      if (File(entity.thumbPath).existsSync()) {
        image = Image.asset(
          entity.thumbPath,
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      } else {
        image = Image.asset(
          FileUtil.getImagePath('img_default', dir: 'default', format: 'png'),
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      }
    } else if (ObjectUtil.isNetUri(entity.thumbPath)) {
      image = Image.network(
        entity.thumbPath,
        width: size,
        height: size,
        fit: BoxFit.fill,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: entity.messageOwner == 1
            ? Colors.white
            : Color.fromARGB(255, 158, 234, 106),
        child: Stack(
          children: <Widget>[
            image,
            Container(
              padding: EdgeInsets.all(40),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 90, top: 98),
              child: Text(
                '${entity.length}秒',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
