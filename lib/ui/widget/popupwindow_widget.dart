import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/functions.dart';
import 'package:flutter_nb/utils/image_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';

class PopupWindowUtil {
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

  /*
  * 选择拍照片、拍视频
  */
  static Future showCameraChosen(BuildContext context, {OnCallBackWithType onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("拍照片"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(1, image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("拍视频"),
                onTap: () async {
                  Navigator.pop(context);
                  InteractNative.goNativeWithValue(
                      InteractNative.methodNames['shootVideo'], null)
                      .then((success) {
                    if (success != null && success is Map) {
                      if (onCallBack != null) {
                        onCallBack(2, success);
                      }
                    } else {
                      DialogUtil.buildToast(success.toString());
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
