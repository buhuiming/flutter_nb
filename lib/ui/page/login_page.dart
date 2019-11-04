import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/main/main_page.dart';
import 'package:flutter_nb/ui/page/register_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/data_proxy.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Login();
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController(
      text: SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT));
  final _passwordController = TextEditingController();
  FocusNode firstTextFieldNode = FocusNode();
  FocusNode secondTextFieldNode = FocusNode();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  Operation operation = new Operation();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: "登录",
        theme: ThemeData(
            primarySwatch: ObjectUtil.getThemeSwatchColor(),
            primaryColor: ObjectUtil.getThemeColor(color: 'white'),
            platform: TargetPlatform.iOS),
        home: new LoadingScaffold(
          //使用有Loading的widget
          operation: operation,
          isShowLoadingAtNow: false,
          child: new Scaffold(
            key: _scaffoldkey,
            backgroundColor: Colors.white,
            primary: true,
            body: SafeArea(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(), //内容不足一屏
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                children: <Widget>[
                  SizedBox(height: 60.0),
                  new Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: new Image.asset(
                          FileUtil.getImagePath('logo',
                              dir: 'splash', format: 'png'),
                          height: 100.0,
                          width: 100.0),
                    ),
                  ),
                  SizedBox(height: 76.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: ObjectUtil.getThemeLightColor(),
                    color: ObjectUtil.getThemeLightColor(),
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
                          hintText: '请输入帐号',
                          prefixIcon: Icon(Icons.phone_android),
                          contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                          filled: true,
//                          // 未获得焦点下划线设为灰色
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.grey),
//                          ),
//                          //获得焦点下划线设为蓝色
//                          focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.blue),
//                          ),
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          )),
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(secondTextFieldNode),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: ObjectUtil.getThemeLightColor(),
                    color: ObjectUtil.getThemeLightColor(),
                    elevation: 5.0,
                    child: new TextField(
                        focusNode: secondTextFieldNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(18),
                          WhitelistingTextInputFormatter(
                              RegExp(Constants.INPUTFORMATTERS))
                        ],
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '请输入密码',
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
                          _checkInput(context, operation);
                        },
                        onSubmitted: (res) {
                          //onEditingComplete和onSubmitted：这两个回调都是在输入框输入完成时触发
                        }),
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    textColor: Colors.white,
                    color: ObjectUtil.getThemeSwatchColor(),
                    padding: EdgeInsets.all(12.0),
                    shape: new StadiumBorder(
                        side: new BorderSide(
                      style: BorderStyle.solid,
                      color: ObjectUtil.getThemeSwatchColor(),
                    )),
                    child: Text('登录', style: new TextStyle(fontSize: 16.0)),
                    onPressed: () {
//                  Navigator.pop(context);
                      _checkInput(context, operation);
                    },
                  ),
                  new Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new CupertinoPageRoute<void>(
                                builder: (ctx) => RegisterPage()));
                      },
                      child: new Container(
                          padding: EdgeInsets.only(right: 12.0, top: 6),
                          child: Text('没有账号？ ',
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black54,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _checkInput(BuildContext context, Operation operation) {
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
    /*operation.setShowLoading(true);
    Observable.just(1).delay(new Duration(milliseconds: 3000)).listen((_) {
      operation.setShowLoading(false);
      DialogUtil.buildToast('登录成功');
      SPUtil.putBool(Constants.KEY_LOGIN, true);
      Navigator.of(context).pushReplacementNamed('/MainPage');
    });*/
    operation.setShowLoading(true);
    Map<String, String> map = {"username": username, "password": password};
    InteractNative.goNativeWithValue(InteractNative.methodNames['login'], map)
        .then((success) {
      operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('登录成功');
        SPUtil.putBool(Constants.KEY_LOGIN, true);
        SPUtil.putString(Constants.KEY_LOGIN_ACCOUNT, username);
//        Navigator.of(context).pushReplacementNamed('/MainPage');
        InteractNative.getAppEventSink()
            .add(InteractNative.CHANGE_PAGE_TO_MAIN);
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('登录失败');
      }
    });
  }
}
