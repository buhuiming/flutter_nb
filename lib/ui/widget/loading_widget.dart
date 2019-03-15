import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/functions.dart';

/*
*  loading page
*/
class LoadingScaffold extends StatefulWidget {
  final bool isShowLoadingAtNow;
  final BackPressType backPressType;
  final BackPressCallback backPressCallback;
  final Operation operation;
  final Widget child;

  const LoadingScaffold(
      {Key key,
      this.isShowLoadingAtNow: false,
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
  VoidCallback listener;
  Future<bool> _onWillPop() => new Future.value(false); //禁掉返回按钮和右滑关闭

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.operation._notifier = ValueNotifier<bool>(false);
    if (widget.isShowLoadingAtNow != true) {
      widget.operation._notifier.value = false;
    } else {
      widget.operation._notifier.value = true;
    }
    listener = () {
      setState(() {
        _hideKeyBord();
      });
    };
    widget.operation._notifier.addListener(listener);
  }

  void _hideKeyBord() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (null != listener) {
      widget.operation._notifier.removeListener(listener);
    }
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
          offstage: widget.operation._notifier.value != true,
          child: widget.operation._notifier.value != true
              ? _loadingWidget()
              : _WillPopScopeWidget(), //显示loading，则禁掉返回按钮和右滑关闭
        )
      ],
    );
  }

  Widget _WillPopScopeWidget() {
    return new WillPopScope(
        onWillPop: () {
          if (null != widget.backPressCallback) {
            widget.backPressCallback(widget.backPressType);
          }
          if (widget.backPressType == BackPressType.SBLOCK) {
            _onWillPop(); //阻止返回
          } else if (widget.backPressType == BackPressType.CLOSE_CURRENT) {
            widget.operation.setShowLoading(false); //关闭当前页
          } else if (widget.backPressType == BackPressType.CLOSE_PARENT) {
            Navigator.pop(context); //关闭当前页及当前页的父页
          }
        },
        child: _loadingWidget());
  }

  Widget _loadingWidget() {
    return new Container(
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
                      decoration: TextDecoration.none,
                    ),
                  )
                ],
              ),
            )));
  }
}

enum BackPressType {
  SBLOCK, //阻止返回
  CLOSE_CURRENT, //关闭当前页
  CLOSE_PARENT //关闭当前页及当前页的父页
}

class Operation {
  ValueNotifier<bool> _notifier;

  void setShowLoading(bool isShow) {
    _notifier.value = isShow;
  }

  bool get isShow => _notifier.value;
}
