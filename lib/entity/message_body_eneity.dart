class MessageBodyEntity {
  String message;//文本
  MessageBodyEntity({this.message});

  MessageBodyEntity.fromMap(Map<String, dynamic> map)
      : this(
    message: map['message'],
        );
}
