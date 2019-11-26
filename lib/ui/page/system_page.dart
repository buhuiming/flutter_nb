import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';

/*class SystemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SystemPageState();
  }
}

class SystemPageState extends State<SystemPage> with TickerProviderStateMixin {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '体系',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  //执行缩放动画
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  '$_count',
                  //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                  key: ValueKey<int>(_count),
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              RaisedButton(
                child: const Text(
                  '+1',
                ),
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                },
              ),
            ],
          ),
        ));
  }
}*/

class SystemPage extends StatefulWidget {
  @override
  _AnimatedWidgetsTestState createState() => _AnimatedWidgetsTestState();
}

class _AnimatedWidgetsTestState extends State<SystemPage> {
  double _padding = 10;
  var _align = Alignment.topRight;
  double _height = 100;
  double _left = 0;
  Color _color = Colors.red;
  TextStyle _style = TextStyle(color: Colors.black);
  Color _decorationColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    var duration = Duration(seconds: 5);
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '体系',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _padding = 20;
                  });
                },
                child: AnimatedPadding(
                  duration: duration,
                  padding: EdgeInsets.all(_padding),
                  child: Text("AnimatedPadding"),
                ),
              ),
              SizedBox(
                height: 50,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: duration,
                      left: _left,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _left = 100;
                          });
                        },
                        child: Text("AnimatedPositioned"),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                color: Colors.grey,
                child: AnimatedAlign(
                  duration: duration,
                  alignment: _align,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        _align = Alignment.center;
                      });
                    },
                    child: Text("AnimatedAlign"),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: duration,
                height: _height,
                color: _color,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _height = 150;
                      _color = Colors.blue;
                    });
                  },
                  child: Text(
                    "AnimatedContainer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              AnimatedDefaultTextStyle(
                child: GestureDetector(
                  child: Text("hello world"),
                  onTap: () {
                    setState(() {
                      _style = TextStyle(
                        color: Colors.blue,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: Colors.blue,
                      );
                    });
                  },
                ),
                style: _style,
                duration: duration,
              ),
              AnimatedDecoratedBox(
                duration: duration,
                decoration: BoxDecoration(color: _decorationColor),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _decorationColor = Colors.red;
                    });
                  },
                  child: Text(
                    "AnimatedDecoratedBox",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ].map((e) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: e,
              );
            }).toList(),
          ),
        ));
  }
}

class AnimatedDecoratedBox extends ImplicitlyAnimatedWidget {
  AnimatedDecoratedBox({
    Key key,
    @required this.decoration,
    this.child,
    Curve curve = Curves.linear, //动画曲线
    @required Duration duration, // 正向动画执行时长
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );
  final BoxDecoration decoration;
  final Widget child;

  @override
  _AnimatedDecoratedBoxState createState() {
    return _AnimatedDecoratedBoxState();
  }
}

class _AnimatedDecoratedBoxState
    extends AnimatedWidgetBaseState<AnimatedDecoratedBox> {
  DecorationTween _decoration; //定义一个Tween

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(visitor) {
    // 在需要更新Tween时，基类会调用此方法
    _decoration = visitor(_decoration, widget.decoration,
        (value) => DecorationTween(begin: value));
  }
}
