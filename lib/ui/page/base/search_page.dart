import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/search_appbar.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';

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
  Operation _operation = new Operation();
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LoadingScaffold(
        operation: _operation,
        backPressType: BackPressType.CLOSE_PARENT, //返回关闭整个页面
        child: new Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(child: ListView()),
          appBar: new SearchAppBarWidget(
              focusNode: _focusNode,
              controller: _controller,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              onEditingComplete: () => _checkInput()),
        ));
  }

  void _checkInput() {
    var username = _controller.text;
    if (username.isEmpty) {
      FocusScope.of(context).requestFocus(_focusNode);
      DialogUtil.buildToast('请输入搜索内容');
      return;
    }
  }
}
