import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
* 通知栏
*/
class NotificationUtil {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');

  static final NotificationUtil _notificationUtil =
      new NotificationUtil._internal();

  static NotificationUtil build() {
    return _notificationUtil;
  }

  NotificationUtil._internal() {
    _init();
  }

  void _init() {
    IOSInitializationSettings initializationSettingsIOS =
        new IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocationLocation);
    InitializationSettings initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  /*
  * iOS端接收到通知所作的处理的方法。
  */
  Future onDidReceiveLocationLocation(
      int id, String title, String body, String payload) async {}

  /*
  *  通知被点击后处理
  */
  Future onSelectNotification(String payload) async {
    print(payload);
  }

  Future showSystem(String title, String content, String payload) async {
    return _show(1, title, content, payload);
  }

  Future showChat(String title, String content, String payload) async {
    return _show(2, title, content, payload);
  }

  Future showOthers(String title, String content, String payload) async {
    return _show(3, title, content, payload);
  }

  Future _show(int type, String title, String content, String payload) async {
    String groupKey;
    String groupChannelId;
    String groupChannelName;
    String groupChannelDescription;
    int id;
    switch (type) {
      case 1:
        id = NotificationConfig.ID_SYSTEM;
        groupKey = NotificationConfig.GROUP_KEY_SYSTEM;
        groupChannelId = NotificationConfig.GROUP_CHANNEL_ID_SYSTEM;
        groupChannelName = NotificationConfig.GROUP_CHANNEL_NAME_SYSTEM;
        groupChannelDescription =
            NotificationConfig.GROUP_CHANNEL_DESCRIPTION_SYSTEM;
        break;
      case 2:
        id = NotificationConfig.ID_CHAT++;
        groupKey = NotificationConfig.GROUP_KEY_CHAT;
        groupChannelId = NotificationConfig.GROUP_CHANNEL_ID_CHAT;
        groupChannelName = NotificationConfig.GROUP_CHANNEL_NAME_CHAT;
        groupChannelDescription =
            NotificationConfig.GROUP_CHANNEL_DESCRIPTION_CHAT;
        break;
      case 3:
        id = NotificationConfig.ID_OTHERS++;
        if (id == 100) {
          NotificationConfig.ID_OTHERS = 2;
          id = 2;
        }
        groupKey = NotificationConfig.GROUP_KEY_OTHERS;
        groupChannelId = NotificationConfig.GROUP_CHANNEL_ID_OTHERS;
        groupChannelName = NotificationConfig.GROUP_CHANNEL_NAME_OTHERS;
        groupChannelDescription =
            NotificationConfig.GROUP_CHANNEL_DESCRIPTION_OTHERS;
        break;
    }

    AndroidNotificationDetails firstNotificationAndroidSpecifics =
        new AndroidNotificationDetails(
            groupChannelId, groupChannelName, groupChannelDescription,
            importance: Importance.Max,
            priority: Priority.High,
            groupKey: groupKey);
    NotificationDetails firstNotificationPlatformSpecifics =
        new NotificationDetails(firstNotificationAndroidSpecifics, null);
    return await flutterLocalNotificationsPlugin.show(
        id, title, content, firstNotificationPlatformSpecifics,
        payload: payload);
  }

  Future cancel({int id}) async {
    return await flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelMessage() async {
    cancel(id: 1);
    for (int id = 100; id < NotificationConfig.ID_CHAT; id++) {
      cancel(id: id);
    }
  }

  Future cancelAll() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class NotificationConfig {
  static const int ID_SYSTEM = 1;
  static const String GROUP_KEY_SYSTEM = '系统推送消息';
  static const String GROUP_CHANNEL_ID_SYSTEM = 'channel_id_system';
  static const String GROUP_CHANNEL_NAME_SYSTEM = '常规推送';
  static const String GROUP_CHANNEL_DESCRIPTION_SYSTEM = '包括好友验证、好友删除等';

  static int ID_CHAT = 100;
  static const String GROUP_KEY_CHAT = '聊天';
  static const String GROUP_CHANNEL_ID_CHAT = 'channel_id_chat';
  static const String GROUP_CHANNEL_NAME_CHAT = '聊天消息推送';
  static const String GROUP_CHANNEL_DESCRIPTION_CHAT = '包括聊天信息等';

  static int ID_OTHERS = 2;
  static const String GROUP_KEY_OTHERS = '其他';
  static const String GROUP_CHANNEL_ID_OTHERS = 'channel_id_others';
  static const String GROUP_CHANNEL_NAME_OTHERS = '其他推送';
  static const String GROUP_CHANNEL_DESCRIPTION_OTHERS = '包括下载、提醒等';
}
