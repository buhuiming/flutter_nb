import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/login_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/sp_util.dart';
import 'package:rxdart/rxdart.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue[300],
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'FlutterDemo'),
        routes: {
          '/LoginPage': (ctx) => LoginPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _subscription = null;
  int _counter = 0;
  Operation operation = new Operation();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addConnectionListener(); //添加监听
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _MyCounter() {
    setState(() {
      _counter = _counter * 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingScaffold(
      //使用有Loading的widget
      operation: operation,
      isShowLoadingAtNow: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '点击的次数：',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue[300],
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.blue,
                )),
                child: Text('退出登录'),
                onPressed: () {
                  _logOut();
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: '看什么看',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _logOut() {
    operation.setShowLoading(true);
    InteractNative.goNativeWithValue(InteractNative.methodNames['logout'])
        .then((success) {
      operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('登出成功');
        SPUtil.putBool(Constants.KEY_LOGIN, false);
        Navigator.of(context).pushReplacementNamed('/LoginPage');
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('登出失败');
      }
    });
  }

  _addConnectionListener() {
    if (null == _subscription) {
      _subscription = InteractNative.dealNativeWithValue()
          .listen(_onEvent, onError: _onError);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _onEvent(Object event) {
    if ('onConnected' == event) {
      //已连接
//        DialogUtil.buildToast('已连接');
    } else if ('user_removed' == event) {
      //显示帐号已经被移除
      DialogUtil.buildToast('帐号已经被移除');
    } else if ('user_login_another_device' == event) {
      //显示帐号在其他设备登录
      DialogUtil.buildToast('帐号在其他设备登录');
      SPUtil.putBool(Constants.KEY_LOGIN, false);
      Navigator.of(context).pushReplacementNamed('/LoginPage');
    } else if ('disconnected_to_service' == event) {
      //连接不到聊天服务器
      DialogUtil.buildToast('连接不到聊天服务器');
    } else if ('no_net' == event) {
      //当前网络不可用，请检查网络设置
      DialogUtil.buildToast('当前网络不可用，请检查网络设置');
    }
  }

  void _onError(Object error) {
    DialogUtil.buildToast(error.toString());
  }
}
