import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationsDetails(),
          payload: payload);

  static Future _notificationsDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channel id", "channel name",
            channelDescription: "channel description",
            importance: Importance.max,
            icon: "@mipmap/ic_launcher"),
        iOS: IOSNotificationDetails());
  }
}
