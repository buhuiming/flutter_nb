import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebViewState();
  }
}

class WebViewState extends State<WebViewPage> {
  WebViewController _webViewController;
  bool _isShowFloatBtn = false;
  void _onPopSelected(String value) {
    switch (value) {
      case "browser":
        break;
      case "share":
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: MoreWidgets.buildAppBar(
        context,
        widget.title,
        centerTitle: true,
        elevation: 2.0,
        onItemDoubleClick: (res) {
          _webViewController.scrollTop();
        },
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          new PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        value: "browser",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.language,
                                    color: ColorT.gray_66,
                                    size: 22.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '浏览器打开',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorT.text_normal,
                                    ),
                                  )
                                ],
                              ),
                            ))),
                    new PopupMenuItem<String>(
                        value: "share",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: ColorT.gray_66,
                                    size: 22.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '分享',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorT.text_normal,
                                    ),
                                  )
                                ],
                              ),
                            ))),
                  ])
        ],
      ),
      body: InkWell(
        onTap: (){
          DialogUtil.buildToast('点击了');
        },
        child: new WebView(
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _webViewController.addListener(() {
              int _scrollY = _webViewController.scrollY.toInt();
              if (_scrollY < 480 && _isShowFloatBtn) {
                _isShowFloatBtn = false;
                setState(() {});
              } else if (_scrollY > 480 && !_isShowFloatBtn) {
                _isShowFloatBtn = true;
                setState(() {});
              }
            });
          },
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
  Widget _buildFloatingActionButton() {
    if (_webViewController == null || _webViewController.scrollY < 480) {
      return null;
    }
    return new FloatingActionButton(
        heroTag: widget.title ?? widget.titleId,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          _webViewController.scrollTop();
        });
  }
}
