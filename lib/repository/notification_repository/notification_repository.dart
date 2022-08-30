import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../services/user_service.dart';

class NotificationRepository {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final UserService _userService = UserService();

  NotificationRepository() {
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(
      initSettings,
    );
  }

  var initSettings = const InitializationSettings(
    android: AndroidInitializationSettings('tc_launcher_icon'),
    iOS: IOSInitializationSettings(),
  );

  Future<void> onSelectNotification(String payload) async {
    print('on select notification');
  }

  //show local notification
  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      String payload = 'Welcome to the Local Notification demo'}) async {
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    var android = const AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max, playSound: true);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    print("Show notification foreground message");
    await flutterLocalNotificationsPlugin!
        .show(0, title, body, platform, payload: payload);
  }

  getNotifications() async {
    var notifications =await _userService.getNotifications();
    return notifications;
  }
}
