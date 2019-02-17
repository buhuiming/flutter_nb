import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/device_util.dart';

/*
*  搜索页
*/
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Search();
  }
}

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchState();
  }
}

class SearchState extends State<Search> {
  Operation operation = new Operation();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LoadingScaffold(
        operation: operation,
        backPressType: BackPressType.CLOSE_PARENT, //返回关闭整个页面
        child: new Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(child: ListView()),
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text('搜索'),
          ),
        ));
  }
}
