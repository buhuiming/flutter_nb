import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/date_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
* 对话页面中的widget
*/
class ChatItemWidgets {
  static Widget buildChatListItem(
      MessageEntity lastEntity, MessageEntity entity) {
    bool _isShowTime = true;
    var showTime; //最终显示的时间
    if (null == lastEntity) {
      _isShowTime = true;
    } else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((int.parse(entity.time) - int.parse(lastEntity.time)) >
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
          _chatItemWidget(entity)
        ],
      ),
    );
  }

  static Widget _chatItemWidget(MessageEntity entity) {
    if (entity.messageOwner == 1) {
      //对方的消息
      return Container(
        margin: EdgeInsets.only(left: 10, right: 90, bottom: 30, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headPortrait(entity.imageUrl),
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
                    DialogUtil.buildToast('点击了消息');
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                )
              ],
            ))
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
                  entity.senderAccount,
                  style: TextStyle(fontSize: 16, color: ColorT.gray_66),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: _contentWidget(entity),
                  onTap: () {
                    DialogUtil.buildToast('点击了消息');
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                )
              ],
            )),
            SizedBox(width: 10),
            _headPortrait(entity.imageUrl),
          ],
        ),
      );
    }
  }

  /*
  *  头像
  */
  static Widget _headPortrait(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: url.isEmpty
          ? Image.asset(
              FileUtil.getImagePath('img_headportrait',
                  dir: 'icon', format: 'png'),
              width: 44,
              height: 44)
          : Image.network(url, width: 44, height: 44),
    );
  }

  /*
  *  内容
  */
  static Widget _contentWidget(MessageEntity entity) {
    Widget widget;
    if (entity.contentType == Constants.CONTENT_TYPE_SYSTEM ||
        entity.contentType == DataBaseControl.payload_contact_contactAdded) {
      //文本
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
          color: entity.messageOwner == 1
              ? Colors.white
              : Color.fromARGB(255, 158, 234, 106),
          child: Text(
            entity.content + "大萨达撒大所大所多撒大所多撒大所大所大萨达所大所大所大大多所大啊大四打死多 ",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      );
    } else if (entity.contentType == Constants.CONTENT_TYPE_IMAGE) {
      //图像
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
}
