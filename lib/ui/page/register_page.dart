import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_nb/utils/timer_util.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Register();
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordSureController = TextEditingController();
  final _aController = TextEditingController();
  Map<String, String> authCodeMap = TimerUtil.getAuthCode();
  FocusNode firstTextFieldNode = FocusNode();
  FocusNode secondTextFieldNode = FocusNode();
  FocusNode thirdTextFieldNode = FocusNode();
  FocusNode aTextFieldNode = FocusNode();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  Operation operation = new Operation();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        theme: ThemeData(
            primaryColor: ObjectUtil.getThemeColor(),
            platform: TargetPlatform.iOS),
        home: new LoadingScaffold(
          //使用有Loading的widget
          operation: operation,
          isShowLoadingAtNow: false,
          backPressType: BackPressType.CLOSE_CURRENT,
          backPressCallback: (backPressType) {
            print(
                'back press and type is ' + backPressType.toString()); //点击了返回键
          },
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
                        WhitelistingTextInputFormatter.digitsOnly,
                      ], //只能输入整数
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: '最大长度为11个数字',
                          prefixIcon: Icon(Icons.phone_android),
                          contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                          filled: true,
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
                        textInputAction: TextInputAction.next,
                        controller: _passwordController,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(18),
                          WhitelistingTextInputFormatter(
                              RegExp(Constants.INPUTFORMATTERS))
                        ],
                        obscureText: false,
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
                          FocusScope.of(context)
                              .requestFocus(thirdTextFieldNode);
                        }),
                  ),
                  SizedBox(height: 12.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: ObjectUtil.getThemeLightColor(),
                    color: ObjectUtil.getThemeLightColor(),
                    elevation: 5.0,
                    child: new TextField(
                        focusNode: thirdTextFieldNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _passwordSureController,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(18),
                          WhitelistingTextInputFormatter(
                              RegExp(Constants.INPUTFORMATTERS))
                        ],
                        obscureText: false,
                        decoration: InputDecoration(
                            labelText: 'Confirm password',
                            hintText: '请确认密码',
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
                          FocusScope.of(context).requestFocus(aTextFieldNode);
                        }),
                  ),
                  SizedBox(height: 12.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: ObjectUtil.getThemeLightColor(),
                    color: ObjectUtil.getThemeLightColor(),
                    elevation: 5.0,
                    child: new TextField(
                      focusNode: aTextFieldNode,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _aController,
                      maxLines: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11), //长度限制11
                        WhitelistingTextInputFormatter.digitsOnly,
                      ], //只能输入整数
                      decoration: InputDecoration(
                          labelText: '验证码',
                          hintText: authCodeMap.keys.elementAt(0),
                          prefixIcon: Icon(Icons.phone_android),
                          contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          )),
                      onEditingComplete: () => _checkInput(context, operation),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  RaisedButton(
                    textColor: Colors.white,
                    color: ObjectUtil.getThemeSwatchColor(),
                    padding: EdgeInsets.all(12.0),
                    shape: new StadiumBorder(
                        side: new BorderSide(
                      style: BorderStyle.solid,
                      color: ObjectUtil.getThemeSwatchColor(),
                    )),
                    child: Text('立即注册', style: new TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      _checkInput(context, operation);
                    },
                  ),
                ],
              ),
            ),
            appBar: MoreWidgets.buildAppBar(
              context,
              '立即注册',
              centerTitle: true,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ),
        ));
  }

  void _checkInput(BuildContext context, Operation operation) {
    var username = _usernameController.text;
    if (username.isEmpty) {
      FocusScope.of(context).requestFocus(firstTextFieldNode);
      DialogUtil.buildToast("please enter username.");
      return;
    }
    var password = _passwordController.text;
    if (password.isEmpty) {
      FocusScope.of(context).requestFocus(secondTextFieldNode);
      DialogUtil.buildToast("please enter password.");
      return;
    }

    var passwordSure = _passwordSureController.text;
    if (passwordSure.isEmpty) {
      FocusScope.of(context).requestFocus(thirdTextFieldNode);
      DialogUtil.buildToast("please enter password.");
      return;
    }
    if (password != passwordSure) {
      FocusScope.of(context).requestFocus(thirdTextFieldNode);
      DialogUtil.buildToast("please enter the same password.");
      return;
    }
    var authCode = _aController.text;
    if (authCode != authCodeMap.values.elementAt(0)) {
      FocusScope.of(context).requestFocus(aTextFieldNode);
      DialogUtil.buildToast("please enter the correct auth code.");
      return;
    }

    operation.setShowLoading(true);
    Map<String, String> map = {"username": username, "password": password};
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['register'], map)
        .then((success) {
      operation.setShowLoading(false);
      if (success == true) {
        DialogUtil.buildToast('注册成功');
        Navigator.pop(context);
      } else if (success is String) {
        DialogUtil.buildToast(success);
      } else {
        DialogUtil.buildToast('注册失败');
      }
    }); //调用原生的方法
    /* Observable.just(1).delay(new Duration(milliseconds: 6000)).listen((_) {
      operation.setShowLoading(false);
      DialogUtil.buildToast('注册成功');
//      Navigator.pop(context);
    });*/
  }
}
