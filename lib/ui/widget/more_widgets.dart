import 'package:flutter/material.dart';

class MoreWidgets {

  /*
  *  生成常用的AppBar
  */
  static Widget buildAppBar(BuildContext context, String text,
      {double fontSize: 18.0, double height: 46.0}) {
    return new PreferredSize(
        child:
            new AppBar(title: Text(text, style: TextStyle(fontSize: fontSize))),
        preferredSize: Size.fromHeight(height));
  }
}
