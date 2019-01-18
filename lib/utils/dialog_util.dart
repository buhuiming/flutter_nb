import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtil {
  static buildToast(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: ColorT.app_main,
        textColor: Colors.white);
  }

  static buildSnakeBar(BuildContext context, String str) {
    final snackBar = new SnackBar(
        content: new Text(str),
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.blue[300]);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //如果context在Scaffold之前，弹不出请用这个
  static buildSnakeBarByKey(String str, GlobalKey<ScaffoldState> key) {
    final snackBar = new SnackBar(
        content: new Text(str),
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.blue[300]);
    key.currentState.showSnackBar(snackBar);
  }
}
