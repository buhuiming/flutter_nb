import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/object_util.dart';

class PayPage extends StatefulWidget {
  final title;

  PayPage(this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PayState();
  }
}

class PayState extends State<PayPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, widget.title),
      body: Center(
        child: RaisedButton(
          textColor: Colors.white,
          color: ObjectUtil.getThemeSwatchColor(),
          padding: EdgeInsets.all(12.0),
          shape: new StadiumBorder(
              side: new BorderSide(
            style: BorderStyle.solid,
            color: ObjectUtil.getThemeSwatchColor(),
          )),
          child:
              Text(widget.title + "页面按钮", style: new TextStyle(fontSize: 16.0)),
          onPressed: () {
            var name = widget.title;
            switch (name) {
              case "A":
                name = "B";
                break;
              case "B":
                name = "C";
                break;
              case "C":
                name = "D";
                break;
              case "D":
                name = "E";
                break;
              case "E":
                name = "F";
                break;
              case "F":
                Navigator.popUntil(context, ModalRoute.withName("C"));
                return;
            }
            Navigator.push(
                context,
                new CupertinoPageRoute<void>(
                    builder: (ctx) => PayPage(name),
                    settings: RouteSettings(name: name)));
          },
        ),
      ),
    );
  }
}
