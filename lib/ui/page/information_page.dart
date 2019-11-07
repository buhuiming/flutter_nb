import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class InformationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InformationPageState();
  }
}

class InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(
          context,
          '资讯',
          centerTitle: true,
          elevation: 2.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: 100,
          padding: EdgeInsets.all(12),
          itemBuilder: (BuildContext context, int index) => new Container(
              color: ObjectUtil.getRandomColor(),
              child: new Center(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text('$index'),
                ),
              )),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ));
  }
}
