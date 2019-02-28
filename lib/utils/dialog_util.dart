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
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //如果context在Scaffold之前，弹不出请用这个
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
        barrierDismissible: true,
        builder: (BuildContext context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: new Text(title),
                titlePadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                content: new Text(content),
                actions: <Widget>[
                  new FlatButton(
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
                  new FlatButton(
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
