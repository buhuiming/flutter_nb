import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/page/circular_progress.dart';
import 'package:flutter_nb/ui/page/information_page.dart';
import 'package:flutter_nb/ui/page/project_page.dart';
import 'package:flutter_nb/ui/page/quality_page.dart';
import 'package:flutter_nb/ui/page/system_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/timer_util.dart';

import '../pyq_page.dart';

/*
*  发现
*/
class FoundPage extends StatefulWidget {
  FoundPage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Found();
  }
}

class Found extends State<FoundPage> with AutomaticKeepAliveClientMixin {
  var progress = 0;
  var length = '00:01:14';
  AudioCache _audioPlayer;
  AudioPlayer _fixedPlayer;
  TimerUtil _timerUtil;

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '发现', actions: <Widget>[
        IconButton(
            icon: Icon(Icons.album),
            onPressed: () {
              if (ObjectUtil.isFastClick()) {
                return;
              }
              if (progress > 0) {
                NotificationUtil.instance()
                    .build(context, null)
                    .cancel(id: 9999);
                _fixedPlayer.stop();
                _timerUtil.cancel();
                length = '00:00:00';
                progress = 0;
                return;
              }
              _fixedPlayer = new AudioPlayer();
              _audioPlayer = new AudioCache(fixedPlayer: _fixedPlayer);
              _timerUtil = new TimerUtil(mTotalTime: 74 * 1000);
              _timerUtil.setOnTimerTickCallback((int tick) {
                double _tick = tick / 1000;
                setState(() {
                  progress = 74 - _tick.toInt();
                  if (_tick.toInt() > 60) {
                    if (_tick.toInt() - 60 >= 10) {
                      length = '00:01:' + (_tick.toInt() - 60).toString();
                    } else {
                      length = '00:01:0' + (_tick.toInt() - 60).toString();
                    }
                  } else if (_tick.toInt() == 60) {
                    length = '00:01:00';
                  } else if (tick > 0) {
                    if (_tick.toInt() >= 10) {
                      length = '00:00:' + _tick.toInt().toString();
                    } else {
                      length = '00:00:0' + _tick.toInt().toString();
                    }
                  } else {
                    length = '00:00:00';
                    progress = 0;
                  }
                  NotificationUtil.instance()
                      .build(context, null)
                      .showMusic(progress, length);
                  if (_tick == 0) {
                    NotificationUtil.instance()
                        .build(context, null)
                        .cancel(id: 9999);
                    _timerUtil.cancel();
                    _fixedPlayer.stop();
                  }
                });
              });
              _timerUtil.startCountDown();
              _audioPlayer.play("sounds/demo.mp3");
            })
      ]),
      body: new ListView(
        children: <Widget>[
          MoreWidgets.defaultListViewItem(Icons.camera, '朋友圈',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30,
              isDivider: false, onItemClick: (res) {
            Navigator.push(context,
                new CupertinoPageRoute<void>(builder: (ctx) => PYQPage()));
            return;
          }),
          MoreWidgets.buildDivider(),
          MoreWidgets.defaultListViewItem(Icons.album, '资讯',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30, onItemClick: (res) {
            Navigator.push(
                context,
                new CupertinoPageRoute<void>(
                    builder: (ctx) => InformationPage()));
            return;
          }),
          MoreWidgets.defaultListViewItem(Icons.airport_shuttle, '干货',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30,
              isDivider: false, onItemClick: (res) {
            Navigator.push(context,
                new CupertinoPageRoute<void>(builder: (ctx) => QualityPage()));
            return;
          }),
          MoreWidgets.buildDivider(),
          MoreWidgets.defaultListViewItem(Icons.dashboard, '项目',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30, onItemClick: (res) {
            Navigator.push(context,
                new CupertinoPageRoute<void>(builder: (ctx) => ProjectPage()));
            return;
          }),
          MoreWidgets.defaultListViewItem(Icons.description, '体系',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30, onItemClick: (res) {
            Navigator.push(context,
                new CupertinoPageRoute<void>(builder: (ctx) => SystemPage()));
            return;
          }),
          MoreWidgets.defaultListViewItem(Icons.insert_link, '小程序',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30, onItemClick: (res) {
            Navigator.push(context,
                new CupertinoPageRoute<void>(builder: (ctx) => GradientCircularProgressRoute()));
            return;
          }, isDivider: false),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
