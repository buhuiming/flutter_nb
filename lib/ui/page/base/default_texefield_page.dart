import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/object_util.dart';

/*
*  常用输入框页面
*/
class DefaultTextFieldPage extends StatelessWidget {
  final String titleText;
  final String contentText;
  final int contentTextMaxLines;
  final int contentTextCount;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final OnSubmitCallback onSubmitCallback;
  DefaultTextFieldPage(
      {@required this.titleText,
      this.contentText: '',
      this.contentTextMaxLines,
      this.contentTextCount: 100,
      this.hintText: '请输入内容',
      this.inputFormatters,
      this.onSubmitCallback,
      Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new DefaultTextField(
      titleText: titleText,
      contentText: contentText,
      contentTextMaxLines: contentTextMaxLines,
      contentTextCount: contentTextCount,
      hintText: hintText,
      inputFormatters: inputFormatters,
      onSubmitCallback: onSubmitCallback,
    );
  }
}

class DefaultTextField extends StatefulWidget {
  final String titleText;
  final String contentText;
  final int contentTextMaxLines;
  final int contentTextCount;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final OnSubmitCallback onSubmitCallback;
  DefaultTextField({
    Key key,
    @required this.titleText,
    this.contentText,
    this.contentTextMaxLines,
    this.contentTextCount,
    this.hintText,
    this.inputFormatters,
    this.onSubmitCallback,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DefaultTextFieldState();
  }
}

class DefaultTextFieldState extends State<DefaultTextField> {
  FocusNode _focusNode = FocusNode();
  Operation _operator = new Operation();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LoadingScaffold(
        operation: _operator,
        backPressType: BackPressType.CLOSE_PARENT, //返回关闭整个页面
        child: new Scaffold(
            backgroundColor: Colors.white,
            primary: true,
            body: SafeArea(
                child: new ListView(
              physics: AlwaysScrollableScrollPhysics(), //内容不足一屏
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                widget.contentText.isNotEmpty
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        child: new Text(
                          widget.contentText,
                          maxLines: widget.contentTextMaxLines,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17.0, color: ColorT.text_dark),
                        ))
                    : Text(''),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30),
                    child: TextField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: _controller,
                        maxLines: 5,
                        maxLength: widget.contentTextCount,
                        inputFormatters: widget.inputFormatters,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: ColorT.text_gray,
                            fontSize: 17,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 12, right: 12, top: 8, bottom: 8),
                          filled: true,
                          fillColor: ColorT.gray_f0,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(8.0))),
                        ),
                        onEditingComplete: () {
                          _checkInput();
                        })),
                RaisedButton(
                  textColor: Colors.white,
                  color: ObjectUtil.getThemeSwatchColor(),
                  padding: EdgeInsets.all(12.0),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                    style: BorderStyle.solid,
                    color: ObjectUtil.getThemeSwatchColor(),
                  )),
                  child: Text('确认', style: new TextStyle(fontSize: 16.0)),
                  onPressed: () {
                    _checkInput();
                  },
                ),
              ],
            )),
            appBar: MoreWidgets.buildAppBar(
              context,
              widget.titleText,
              centerTitle: true,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )));
  }

  void _checkInput() {
    var text = _controller.text;
    if (text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusNode);
      DialogUtil.buildToast(widget.hintText);
      return;
    }
    if (widget.onSubmitCallback != null) {
      widget.onSubmitCallback(text, _operator, context);
    }
  }
}