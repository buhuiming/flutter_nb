import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
*  发现
*/
class FoundPage extends StatefulWidget {
  FoundPage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Found();
  }
}

class Found extends State<FoundPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '发现'),
      body: new ListView(
        children: <Widget>[
          MoreWidgets.defaultListViewItem(Icons.camera, '朋友圈',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30,
              isDivider: false),
          MoreWidgets.buildDivider(),
          MoreWidgets.defaultListViewItem(Icons.album, '资讯',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30),
          MoreWidgets.defaultListViewItem(Icons.airport_shuttle, '干货',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30,
              isDivider: false),
          MoreWidgets.buildDivider(),
          MoreWidgets.defaultListViewItem(Icons.dashboard, '项目',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30),
          MoreWidgets.defaultListViewItem(Icons.description, '体系',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30),
          MoreWidgets.defaultListViewItem(Icons.insert_link, '小程序',
              textColor: Colors.black,
              iconColor: ObjectUtil.getThemeSwatchColor(),
              imageSize: 30,
              isDivider: false),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
