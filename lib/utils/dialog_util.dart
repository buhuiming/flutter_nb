import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtil {
  static buildToast(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: ObjectUtil.getThemeSwatchColor(),
        textColor: Colors.white);
  }

  static buildSnakeBar(BuildContext context, String str) {
    final snackBar = new SnackBar(
        content: new Text(str),
        duration: Duration(milliseconds: 1500),
        backgroundColor: ObjectUtil.getThemeSwatchColor());
    Scaffold.of(context).showSnackBar(
        snackBar); //Scaffold.of(context)是一个state，context对应的state必须的暴露的
  }

  //如果context在Scaffold之前，弹不出请用这个
  //使用GlobalKey开销较大，如果有其他可选方案，应尽量避免使用它
  static buildSnakeBarByKey(String str, GlobalKey<ScaffoldState> key) {
    final snackBar = new SnackBar(
        content: new Text(str),
        duration: Duration(milliseconds: 1500),
        backgroundColor: ObjectUtil.getThemeSwatchColor());
    key.currentState.showSnackBar(snackBar);
  }

  /*
  * 普通dialog
  */
  static showBaseDialog(BuildContext context, String content,
      {String title = '提示',
      String left = '取消',
      String right = '确认',
      OnItemClick leftClick,
      OnItemClick rightClick}) {
    showDialog(
        context: context,
        barrierDismissible: true, //点击对话框barrier(遮罩)时是否关闭它
        builder: (BuildContext context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: ObjectUtil.isEmpty(title)
                    ? SizedBox(
                        width: 0,
                        height: 10,
                      )
                    : new Text(title),
                titlePadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                content: new Text(content),
                actions: <Widget>[
                  ObjectUtil.isEmpty(left)
                      ? SizedBox(
                          width: 0,
                          height: 15,
                        )
                      : FlatButton(
                          child: new Text(
                            left,
                            style: TextStyle(color: ColorT.app_main),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (null != leftClick) {
                              leftClick(null);
                            }
                          },
                        ),
                  ObjectUtil.isEmpty(right)
                      ? SizedBox(
                          width: 0,
                          height: 15,
                        )
                      : FlatButton(
                          child: new Text(
                            right,
                            style: TextStyle(color: ObjectUtil.getThemeColor()),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (null != rightClick) {
                              rightClick(null);
                            }
                          },
                        )
                ]));
  }
}
