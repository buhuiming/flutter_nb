import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/image_util.dart';

class PopupWidowUtil {
  /*
  * 选择相机相册
  */
  static Future showPhotoChosen(BuildContext context, {OnCallBack onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("拍照"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("相册"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getGalleryImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
