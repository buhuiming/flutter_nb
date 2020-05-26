import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/page/base/web_view_page.dart';
import 'package:flutter_nb/ui/page/main/main_page.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';
import 'package:flutter_nb/utils/timer_util.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;
  int _count = 3;
  int _status = 0; //0启动页，1广告页，2引导页
  TimerUtil _timerUtil;
  List<String> _guideList = [
    FileUtil.getImagePath('guide1', dir: 'splash'),
    FileUtil.getImagePath('guide2', dir: 'splash'),
    FileUtil.getImagePath('guide3', dir: 'splash'),
    FileUtil.getImagePath('guide4', dir: 'splash')
  ];
  List<Widget> _guideWidgetList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTools();
    _checkPage();
  }

  void _initTools() async {
    await SPUtil.getInstance();
  }

  void _checkPage() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (SPUtil.getBool(Constants.KEY_LOGIN) != true) {
        isLogin = false;
      } else {
        isLogin = true;
      }
      if (SPUtil.getBool(Constants.KEY_GUIDE) != true &&
          ObjectUtil.isNotEmpty(_guideList)) {
        //show guide page
        _initGuide();
      } else {
        _initSplash();
      }
    });
  }

  _initGuide() {
    _initGuideData();
    setState(() {
      _status = 2;
    });
  }

  _initSplash() {
    setState(() {
      _status = 1;
    });
    _timerUtil = new TimerUtil(mTotalTime: 3 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _goNext();
      }
    });
    _timerUtil.startCountDown();
  }

  _initGuideData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _guideWidgetList.add(new Stack(
          children: <Widget>[
            _newImageWidget(i),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 50.0),
                width: 120.0,
                height: 36.0,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: ObjectUtil.getThemeColor(),
                    shape: new StadiumBorder(
                        side: new BorderSide(
                      style: BorderStyle.solid,
                      color: ObjectUtil.getThemeColor(),
                    )),
                    child: Text('立即体验'),
                    onPressed: () {
                      SPUtil.putBool(Constants.KEY_GUIDE, true);
                      _goNext();
                    }),
              ),
            )
          ],
        ));
      } else {
        _guideWidgetList.add(_newImageWidget(i));
      }
    }
  }

  _newImageWidget(int i) {
    return new Image.asset(
      _guideList[i],
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildSplashBg() {
    return new Image.asset(
      FileUtil.getImagePath('splash_bg', dir: 'splash'),
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  Widget _buildAdWidget() {
    return new Offstage(
      offstage: !(_status == 1),
      child: new InkWell(
        onTap: () {
          _goNext();
          Navigator.push(
              context,
              new CupertinoPageRoute<void>(
                  builder: (ctx) => new WebViewPage(
                        title: 'Github',
                        url: Constants.GITHUB_URL,
                      )));
        },
        child: new Container(
          alignment: Alignment.center,
          child: new CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            imageUrl: Constants.URL_ADVERTISING,
            placeholder: (context, url) => _buildSplashBg(),
            errorWidget: (context, url, error) => _buildSplashBg(),
          ),
        ),
      ),
    );
  }

  _goNext() {
    if (isLogin) {
      _autoLogin();
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return MainPage(isShowLogin: false);
      }), (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return MainPage(isShowLogin: true);
      }), (Route<dynamic> route) => false);
    }
  }

  _autoLogin() {
    InteractNative.goNativeWithValue(InteractNative.methodNames['autoLogin']);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          ),
          new Offstage(
              offstage: !(_status == 2),
              child: ObjectUtil.isEmpty(_guideWidgetList)
                  ? new Container()
                  : new Swiper(
                      autoStart: false,
                      circular: false,
                      indicator: CircleSwiperIndicator(
                          radius: 4.0,
                          padding: EdgeInsets.only(bottom: 30.0),
                          itemColor: Colors.red,
                          itemActiveColor: Colors.white),
                      children: _guideWidgetList)),
          _buildAdWidget(),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () => _goNext(),
                child: new Container(
                  padding: EdgeInsets.all(12.0),
                  child: new Text(
                    '跳过 $_count',
                    style: new TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  decoration: new BoxDecoration(
                      color: Color(0x66000000),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border:
                          new Border.all(width: 0.33, color: ColorT.divider)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (null != _timerUtil) {
      _timerUtil.cancel();
    }
  }
}
