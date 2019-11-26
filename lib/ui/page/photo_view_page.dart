import 'dart:io';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:photo_view/photo_view.dart';

/*
*  图片查看
*/
class PhotoViewPage extends StatelessWidget {
  final List<String> images;

  PhotoViewPage({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    List<Widget> _listWidget = new List();
    for (String url in images) {
      _listWidget.add(_itemWidget(url));
    }
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

  Widget _itemWidget(String url) {
    return PhotoView(
      imageProvider:
      url.startsWith("http") ? NetworkImage(url) : FileImage(File(url)),
    );
  }
}
