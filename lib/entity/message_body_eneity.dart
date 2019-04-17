class MessageBodyEntity {
  /*文本*/
  String message; //文本
  /*图像*/
  String fileName;
  int height;
  int width;
  int length;
  int duration;
  int videoFileLength;
  String remoteUrl; //远程图、远程视频
  String thumbnailUrl; //缩略图
  bool sendOriginalImage;
  MessageBodyEntity(
      {this.message,
        this.fileName,
        this.height,
        this.width,
        this.length,
        this.videoFileLength,
        this.duration,
        this.remoteUrl,
        this.thumbnailUrl,
        this.sendOriginalImage});

  MessageBodyEntity.fromMap(Map<String, dynamic> map)
      : this(
    message: map['message'],
    fileName: map['fileName'],
    height: map['height'],
    width: map['width'],
    length: map['length'],
    duration: map['duration'],
    videoFileLength: map['videoFileLength'],
    remoteUrl: map['remoteUrl'],
    thumbnailUrl: map['thumbnailUrl'],
    sendOriginalImage: map['sendOriginalImage'],
  );
}
