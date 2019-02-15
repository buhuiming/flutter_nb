import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';

/*
*  朋友
*/
class FriendsPage extends StatefulWidget {
  FriendsPage({Key key, this.operation, this.rootContext}) : super(key: key);
  final Operation operation;
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Friends();
  }
}

class Friends extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '朋友'),
      body: new ListView(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          MoreWidgets.buildListViewItem('logo', '新的朋友', dir: 'splash'),
          MoreWidgets.buildListViewItem('group_chat', '群聊'),
          MoreWidgets.buildListViewItem('collection', '收藏'),
          MoreWidgets.buildListViewItem('official_accounts', '公众号'),
        ],
      ),
    );
  }
}
