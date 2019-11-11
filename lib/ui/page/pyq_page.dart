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

class PYQPageState1 extends State<PYQPage> {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  @override
  Widget build(BuildContext context) {
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
        body: Stack(
          children: <Widget>[
            Positioned(
              top: _top,
              left: _left,
              child: GestureDetector(
                child: CircleAvatar(child: Text("A")),
                //手指按下时会触发此回调
                onPanDown: (DragDownDetails e) {
                  //打印手指按下的位置(相对于屏幕)
                  print("用户手指按下：${e.globalPosition}");
                },
                //手指滑动时会触发此回调
                onPanUpdate: (DragUpdateDetails e) {
                  //用户手指滑动时，更新偏移，重新构建
                  setState(() {
                    _left += e.delta.dx;
                    _top += e.delta.dy;
                  });
                },
                onPanEnd: (DragEndDetails e) {
                  //打印滑动结束时在x、y轴上的速度
                  print(e.velocity);
                },
              ),
            )
          ],
        ));
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
                    moveOffset =
                        detail.globalPosition - lastStartOffset + idleOffset;
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
