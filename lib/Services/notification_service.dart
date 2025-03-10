import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyNotification({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    if (!enabled) {
      await cancelNotifications();
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_motivation',
      'Daily Motivation',
      channelDescription: 'Daily motivational quotes',
      importance: Importance.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    final effectiveDate =
        scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;

    await _notificationsPlugin.zonedSchedule(
      0,
      'Daily Motivation',
      'Time for your daily dose of motivation!',
      tz.TZDateTime.from(effectiveDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
