import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/page/base/search_page.dart';
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

class Friends extends State<FriendsPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '朋友'),
      body: new ListView(
        children: <Widget>[
          new InkWell(
            //点击带波纹的控件
            onTap: () {
              Navigator.push(
                  context,
                  new CupertinoPageRoute<void>(
                      builder: (ctx) =>
                          SearchPage(Constants.FUNCTION_SEARCH_FRIENDS)));
            },
            child: MoreWidgets.buildListViewItem('logo', '新的朋友', dir: 'splash'),
          ),
          new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new CupertinoPageRoute<void>(
                      builder: (ctx) =>
                          SearchPage('')));
            },
            child: MoreWidgets.buildListViewItem('group_chat', '群聊'),
          ),
          new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new CupertinoPageRoute<void>(
                      builder: (ctx) =>
                          SearchPage('')));
            },
            child: MoreWidgets.buildListViewItem('collection', '收藏'),
          ),
          new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new CupertinoPageRoute<void>(
                      builder: (ctx) =>
                          SearchPage('')));
            },
            child: MoreWidgets.buildListViewItem('official_accounts', '公众号'),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
