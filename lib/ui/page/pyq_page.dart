import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/object_util.dart';

class PYQPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PYQPageState();
  }
}

class PYQPageState extends State<PYQPage> {
  TouchMovePainter painter;
  static final double _width =
      window.physicalSize.width / (window.devicePixelRatio); //屏幕宽度，offset
  static final double _height =
      window.physicalSize.height / (window.devicePixelRatio); //屏幕高度，offset
  //静止状态下的offset
  Offset idleOffset = Offset(
      _width / 2 - 30, //30是圆球的半径
      _height / 2 - 30 - 48); //48是titleBar的高度
  //本次移动的offset    屏幕尺寸像素/设备像素比，就是Offset的屏幕可视最大值
  Offset moveOffset = Offset(
      _width / 2 - 30, //30是圆球的半径
      _height / 2 - 30 - 48); //48是titleBar的高度
  //最后一次down事件的offset
  Offset lastStartOffset = Offset(0, 0);

  @override
  void initState() {
    painter = TouchMovePainter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '朋友圈',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Transform.translate(
            offset: moveOffset,
            child: Container(
              height: 60,
              width: 60,
              child: GestureDetector(
                onPanStart: (detail) {
                  setState(() {
                    lastStartOffset = detail.globalPosition; //记录移动前的位置
                    painter = TouchMovePainter();
                    painter.painterColor = Colors.red;
                  });
                },
                onPanUpdate: (detail) {
                  setState(() {
                    moveOffset = detail.globalPosition -
                        lastStartOffset +
                        idleOffset;
                    moveOffset =
                        Offset(max(0, moveOffset.dx), max(0, moveOffset.dy));
                  });
                },
                onPanEnd: (detail) {
                  setState(() {
                    painter = TouchMovePainter();
                    painter.painterColor = ObjectUtil.getThemeColor();
                    idleOffset = moveOffset * 1;
                  });
                },
                child: CustomPaint(
                  painter: painter,
                ),
              ),
            )));
  }
}

class TouchMovePainter extends CustomPainter {
  var painter = Paint();
  var painterColor = ObjectUtil.getThemeColor();

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = painterColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        min(size.height, size.width) / 2, painter);
  }

  @override
  bool shouldRepaint(TouchMovePainter oldDelegate) {
    return oldDelegate.painterColor != painterColor;
  }
}
