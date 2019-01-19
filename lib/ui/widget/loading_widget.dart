import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';

/*
*  loading page
*/
class LoadingScaffold extends StatefulWidget {
  final bool isShowAtNow;
  final BackPressType backPressType;
  final BackPressCallback backPressCallback;
  final Operation operation;
  final Widget child;

  const LoadingScaffold(
      {Key key,
      this.isShowAtNow: false,
      this.backPressType: BackPressType.CLOSE_CURRENT,
      this.backPressCallback,
      @required this.operation,
      @required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoadingState();
  }
}

class LoadingState extends State<LoadingScaffold> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: <Widget>[
        new Offstage(
          offstage: false,
          child: widget.child,
        ),
        new Offstage(
          offstage: (widget.isShowAtNow != true || widget.operation.isShow != true),
          child: new Container(
              alignment: Alignment.center,
              color: ColorT.transparent_50,
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: new Container(
                    alignment: Alignment.center,
                    color: ColorT.transparent_80,
                    width: 220.0,
                    height: 90.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 28.0,
                          height: 28.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2.5,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          '玩命加载中...',
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  ))),
        )
      ],
    );
  }
}

enum BackPressType {
  sBLOCK, //阻止返回
  CLOSE_CURRENT, //关闭当前页
  CLOSE_PARENT //关闭当前页及当前页的父页
}

typedef BackPressCallback = Future<void> Function(); //按返回键时触发

class Operation {
  bool isShow;
  Operation({this.isShow = false});

  void show() {
    isShow = true;
  }
  void hide() {
    isShow = false;
  }
}
