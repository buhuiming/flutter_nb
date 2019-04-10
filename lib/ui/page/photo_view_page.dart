import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:photo_view/photo_view.dart';

/*
*  图片查看
*/
class PhotoViewPage extends StatefulWidget {
  final List<String> images;

  PhotoViewPage({Key key, this.images}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoViewPage> {
  List<Widget> _listWidget = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  _initData() {
    for (String url in widget.images) {
      _listWidget.add(_itemWidget(url));
    }
  }

  Widget _itemWidget(String url) {
    return PhotoView(
      imageProvider:
          url.startsWith("http") ? NetworkImage(url) : AssetImage(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: Swiper(
          autoStart: false,
          circular: false,
          indicator: CircleSwiperIndicator(
              radius: 4.0,
              padding: EdgeInsets.only(bottom: 20.0),
              itemColor: ColorT.gray_99,
              itemActiveColor: ObjectUtil.getThemeSwatchColor()),
          children: _listWidget),
      onTap: () {
        Navigator.pop(context);
      },
    ));
  }
}
