import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';

class Functions {}

typedef BackPressCallback = Future<void> Function(BackPressType); //按返回键时触发

typedef OnChangedCallback = Future<void> Function(); //输入内容变化时触发

typedef OnSubmitCallback = Future<void> Function(
    Object, Operation, BuildContext); //输入完成时触发

typedef OnItemClick = Future<void> Function(Object); //控件点击时触发

typedef OnItemLongClick = Future<void> Function(Object); //控件点击时触发
