import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/login_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/sp_util.dart';

class MinePage extends StatelessWidget {
  MinePage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue[300],
          primarySwatch: Colors.blue,
        ),
        home: Mine(
          title: 'FlutterDemo',
          operation: operation,
          rootContext: rootContext,
        ),
        routes: {
          '/LoginPage': (ctx) => LoginPage(),
        });
  }
}

class Mine extends StatefulWidget {
  Mine({Key key, this.title, this.operation, this.rootContext})
      : super(key: key);
  final String title;
  final Operation operation;
  final BuildContext rootContext;

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  _logOut() {
    widget.operation.setShowLoading(true);
    InteractNative.goNativeWithValue(InteractNative.methodNames['logout'])
        .then((success) {
      widget.operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('登出成功');
        SPUtil.putBool(Constants.KEY_LOGIN, false);
        Navigator.of(widget.rootContext).pushReplacementNamed('/LoginPage');
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('登出失败');
      }
    });
  }
}
