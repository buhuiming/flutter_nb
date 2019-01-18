import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/ui/page/main_page.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new MaterialApp(
        title: "登录",
        theme:
            ThemeData(primaryColor: Colors.white, platform: TargetPlatform.iOS),
        home: new Login(),
        routes: {
          '/MainPage': (ctx) => MainPage(),
        });
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode firstTextFieldNode = FocusNode();
  FocusNode secondTextFieldNode = FocusNode();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      primary: true,
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        children: <Widget>[
          SizedBox(height: 60.0),
          Column(
            children: <Widget>[
              Image.asset('assets/images/logo.png', height: 80, width: 80),
              SizedBox(height: 16.0),
              Text('SHRINE'),
            ],
          ),
          SizedBox(height: 60.0),
          new Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.blue[300],
            color: Colors.blue[300],
            elevation: 5.0,
            child: new TextField(
              focusNode: firstTextFieldNode,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              controller: _usernameController,
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(11), //长度限制11
                WhitelistingTextInputFormatter.digitsOnly
              ], //只能输入整数
              decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.phone_android),
                  contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(secondTextFieldNode),
            ),
          ),
          SizedBox(height: 12.0),
          new Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.blue[300],
            color: Colors.blue[300],
            elevation: 5.0,
            child: new TextField(
                focusNode: secondTextFieldNode,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(18)],
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    )),
                onEditingComplete: () {
                  _checkInput(context);
                }),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  _usernameController.clear();
                  _passwordController.clear();
                  FocusScope.of(context).requestFocus(firstTextFieldNode);
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue[300],
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.blue,
                )),
                child: Text('LOGIN'),
                onPressed: () {
//                  Navigator.pop(context);
                  _checkInput(context);
                },
              )
            ],
          )
        ],
      )),
    );
  }

  void _checkInput(BuildContext context) {
    var username = _usernameController.text;
    if (username.isEmpty) {
      FocusScope.of(context).requestFocus(firstTextFieldNode);
//      DialogUtil.buildSnakeBarByKey( "please enter username.", _scaffoldkey);
      DialogUtil.buildToast("please enter username.");
      return;
    }
    var password = _passwordController.text;
    if (password.isEmpty) {
      FocusScope.of(context).requestFocus(secondTextFieldNode);
//      DialogUtil.buildSnakeBarByKey( "please enter password.", _scaffoldkey);
      DialogUtil.buildToast("please enter password.");
      return;
    }

    if (username != '15066668888') {
      FocusScope.of(context).requestFocus(firstTextFieldNode);
      DialogUtil.buildToast("username is 15066668888.");
      return;
    }

    if (password != '123456') {
      FocusScope.of(context).requestFocus(firstTextFieldNode);
      DialogUtil.buildToast("username is 123456.");
      return;
    }
    Navigator.of(context).pushReplacementNamed('/MainPage');
  }
}
