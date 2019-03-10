import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/ui/page/base/messag_state.dart';
import 'package:flutter_nb/ui/page/base/search_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/interact_vative.dart';

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

class Friends extends MessageState<FriendsPage>
    with AutomaticKeepAliveClientMixin {
  var list = List();

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setDefault();
    _getFriends();
  }

  _setDefault(){
    list.add('新的朋友');
    list.add('群聊');
    list.add('收藏');
    list.add('公众号');
  }

  _getFriends() {
    InteractNative.goNativeWithValue(
            InteractNative.methodNames['getAllContacts'], null)
        .then((success) {
      if (null != success && success is List) {
        setState(() {
          for (String ms in success) {
            if (!list.contains(ms)) {
              list.add(ms);
            }
          }
        });
      }
    });
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(context, '朋友'),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(index);
          },
          itemCount: list.length),
    );
  }

  Widget _itemWidget(int index) {
    switch (index) {
      case 0:
        return InkWell(
          //点击带波纹的控件
          onTap: () {
            Navigator.push(
                context,
                new CupertinoPageRoute<void>(
                    builder: (ctx) =>
                        SearchPage(Constants.FUNCTION_SEARCH_FRIENDS)));
          },
          child:
              MoreWidgets.buildListViewItem('logo', list[index], dir: 'splash'),
        );
      case 1:
        return InkWell(
          onTap: () {},
          child: MoreWidgets.buildListViewItem('group_chat', list[index]),
        );
      case 2:
        return InkWell(
          onTap: () {},
          child: MoreWidgets.buildListViewItem('collection', list[index]),
        );
      case 3:
        return InkWell(
          onTap: () {},
          child:
              MoreWidgets.buildListViewItem('official_accounts', list[index]),
        );
      default:
        return InkWell(
          onTap: () {},
          child: MoreWidgets.buildListViewItem('img_headportrait', list[index]),
        );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void updateData(MessageEntity entity) {
    // TODO: implement updateData
    if (entity != null &&
        entity.type == Constants.MESSAGE_TYPE_CHAT &&
        (entity.contentType == DataBaseControl.payload_contact_contactAdded ||
            entity.contentType ==
                DataBaseControl.payload_contact_contactDeleted)) {
      //如果收到的推送消息是聊天消息，并且属于好友增加、好友删除，则属性好友列表
      print('获取朋友列表');
      list.remove(entity.senderAccount);
      _getFriends();
    }
  }
}
