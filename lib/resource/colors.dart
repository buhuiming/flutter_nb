import 'package:flutter/material.dart';

/*
1.colorPrimary 应用的主要色调，actionBar默认使用该颜色，Toolbar导航栏的底色
2.colorPrimaryDark 应用的主要暗色调，statusBarColor默认使用该颜色
3.statusBarColor 状态栏颜色，默认使用colorPrimaryDark
4.windowBackground 窗口背景颜色
5.navigationBarColor 底部栏颜色
6.colorForeground 应用的前景色，ListView的分割线，switch滑动区默认使用该颜色
7.colorBackground 应用的背景色，popMenu的背景默认使用该颜色
8.colorAccent CheckBox，RadioButton，SwitchCompat等一般控件的选中效果默认采用该颜色
9.colorControlNormal CheckBox，RadioButton，SwitchCompat等默认状态的颜色。
10.colorControlHighlight 控件按压时的色调
11.colorControlActivated 控件选中时的颜色，默认使用colorAccent
12.colorButtonNormal 默认按钮的背景颜色
13.editTextColor：默认EditView输入框字体的颜色。
14.textColor Button，textView的文字颜色
15.textColorPrimaryDisableOnly RadioButton checkbox等控件的文字
16.textColorPrimary 应用的主要文字颜色，actionBar的标题文字默认使用该颜色
17.colorSwitchThumbNormal: switch thumbs 默认状态的颜色. (switch off)
*/
class ColorT {
  static const Color app_main = Color(0xFF666666);
  static const Color transparent_80 = Color(0x80000000); //204
  static const Color transparent_50 = Color(0x50000000); //204

  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFF666666);
  static const Color text_gray = Color(0xFF999999);

  static const Color divider = Color(0xffe5e5e5);

  static const Color gray_33 = Color(0xFF333333); //51
  static const Color gray_66 = Color(0xFF666666); //102
  static const Color gray_99 = Color(0xFF999999); //153
  static const Color common_orange = Color(0XFFFC9153); //252 145 83
  static const Color gray_ef = Color(0XFFEFEFEF); //153

  static const Color gray_f0 = Color(0xfff0f0f0); //204
  static const Color gray_f5 = Color(0xfff5f5f5); //204
  static const Color gray_cc = Color(0xffcccccc); //204
  static const Color gray_ce = Color(0xffcecece); //206
  static const Color green_1 = Color(0xff009688); //204
  static const Color green_62 = Color(0xff626262); //204
  static const Color green_e5 = Color(0xffe5e5e5); //204
}

Map<String, Color> circleAvatarMap = {
  'A': Colors.blueAccent,
  'B': Colors.blue,
  'C': Colors.cyan,
  'D': Colors.deepPurple,
  'E': Colors.deepPurpleAccent,
  'F': Colors.blue,
  'G': Colors.green,
  'H': Colors.lightBlue,
  'I': Colors.indigo,
  'J': Colors.blue,
  'K': Colors.blue,
  'L': Colors.lightGreen,
  'M': Colors.blue,
  'N': Colors.brown,
  'O': Colors.orange,
  'P': Colors.purple,
  'Q': Colors.black,
  'R': Colors.red,
  'S': Colors.blue,
  'T': Colors.teal,
  'U': Colors.purpleAccent,
  'V': Colors.black,
  'W': Colors.brown,
  'X': Colors.blue,
  'Y': Colors.yellow,
  'Z': Colors.grey,
  '#': Colors.blue,
};

Map<String, Color> themeColorMap = {
  'red': Colors.red,
  'pink': Colors.pink,
  'purple': Colors.purple,
  'deepPurple': Colors.deepPurple,
  'indigo': Colors.indigo,
  'blue': Colors.blue,
  'lightBlue': Colors.lightBlue,
  'cyan': Colors.cyan,
  'teal': Colors.teal,
  'green': Colors.green,
  'lightGreen': Colors.lightGreen,
  'lime': Colors.lime,
  'yellow': Colors.yellow,
  'amber': Colors.amber,
  'orange': Colors.orange,
  'deepOrange': Colors.deepOrange,
  'brown': Colors.brown,
  'blueGrey': Colors.blueGrey,
  'white': Colors.white,
  'black': Colors.black,
};
Map<String, Color> themeSwatchColorMap = {
  'red': Colors.red,
  'pink': Colors.pink,
  'purple': Colors.purple,
  'deepPurple': Colors.deepPurple,
  'indigo': Colors.indigo,
  'blue': Colors.blue,
  'lightBlue': Colors.lightBlue,
  'cyan': Colors.cyan,
  'teal': Colors.teal,
  'green': Colors.green,
  'lightGreen': Colors.lightGreen,
  'lime': Colors.lime,
  'yellow': Colors.yellow,
  'amber': Colors.amber,
  'orange': Colors.orange,
  'deepOrange': Colors.deepOrange,
  'brown': Colors.brown,
  'blueGrey': Colors.blueGrey,
  'white': Colors.red, //白色不是MaterialColor
  'black': Colors.blue, //黑色不是MaterialColor
};
