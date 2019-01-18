class FileUtil {
  static String getImagePath(String name, {String format: 'jpg'}) {
    return 'assets/images/$name.$format';
  }
}
