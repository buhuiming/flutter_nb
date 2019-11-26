import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rxdart/rxdart.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProjectPageState();
  }
}

/*//需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin
class ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(seconds: 3), vsync: this);
    //使用弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 200.0).animate(animation);
//      ..addListener(() {
//        setState(() => {});
//      });//使用AnimatedImage、AnimatedBuilder，不用显式的去添加帧监听器，然后再调用setState()，addListener和setState注释掉

*/ /*    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        controller.forward();
      }
    });*/ /*
    Observable.just(1).delay(new Duration(milliseconds: 1200)).listen((_) {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '项目',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
//        body: new Center(
//          child: Image.asset(
//              FileUtil.getImagePath('img_fest', format: 'png'),
//              width: animation.value,
//              height: animation.value),
//        ));

//        //通过addListener()和setState() 来更新UI这一步其实是通用的，如果每个动画中都加这么
//        // 一句是比较繁琐的。AnimatedWidget类封装了调用setState()的细节，并允许我们将widget分离出来
//        body: AnimatedImage(
//          animation: animation,
//        ));

        body: AnimatedBuilder(
          animation: animation,
          child: Image.asset(FileUtil.getImagePath('img_fest', format: 'png')),
          builder: (BuildContext ctx, Widget child) {
            return new Center(
              child: Container(
                height: animation.value,
                width: animation.value,
                child: InkWell(
                  child: Hero(
                    tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
                    child: child,
                  ),
                  onTap: () {
                    //自定义路由
                    Navigator.push(context, PageRouteBuilder(pageBuilder:
                        (BuildContext context, Animation animation,
                            Animation secondaryAnimation) {
                      return new FadeTransition(
                        opacity: animation,
                        child: HeroAnimationRouteB(),
                      );
                    }));
                  },
                ),
//                child: IFileUtil.getImagePath('img_fest', format: 'png')),
              ),
            );
          },
        ));
  }

  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}

class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: Image.asset(FileUtil.getImagePath('img_fest', format: 'png'),
          width: animation.value, height: animation.value),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '大图显示',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: Hero(
            tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
            child: Image.asset(
              FileUtil.getImagePath('img_fest', format: 'png'),
              width: 400,
              height: 400,
              fit: BoxFit.contain,//如果不定义fit，那么宽高最大只会是图片本身的大小
            ),
          ),
        ));
  }
}*/

//交织动画
class ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '项目',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _playAnimation();
          },
          child: Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              //调用我们定义的交织动画Widget
              child: StaggerAnimation(controller: _controller),
            ),
          ),
        ));
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    //高度动画
    height = Tween<double>(
      begin: .0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }

  final Animation<double> controller;
  Animation<double> height;
  Animation<EdgeInsets> padding;
  Animation<Color> color;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: 50.0,
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
