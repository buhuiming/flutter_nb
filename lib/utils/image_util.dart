import 'package:image_picker/image_picker.dart';

class ImageUtil {
  /*
  * 从相机取图片
  */
  static Future getCameraImage() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  /*
  * 从相册取图片
  */
  static Future getGalleryImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
