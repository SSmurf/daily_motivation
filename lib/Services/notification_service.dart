import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/notification_time.dart';

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
    print("NotificationService initialized.");
  }

  Future<void> scheduleDailyNotifications({
    required bool enabled,
    required List<NotificationTime> times,
  }) async {
    await cancelNotifications();
    if (!enabled || times.isEmpty) {
      print("No notifications scheduled. Enabled: $enabled, Times count: ${times.length}");
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

    for (int i = 0; i < times.length; i++) {
      final time = times[i];
      final now = DateTime.now();
      final scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final effectiveDate =
          scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;

      print("Scheduling notification $i at $effectiveDate for time: $time");

      await _notificationsPlugin.zonedSchedule(
        i,
        'Daily Motivation',
        'Your random quote is ready!',
        tz.TZDateTime.from(effectiveDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> sendDebugNotification() async {
    // Sends an immediate notification for debug purposes.
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'debug_channel',
      'Debug Notifications',
      channelDescription: 'Debug notifications',
      importance: Importance.max,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    await _notificationsPlugin.show(
      999,
      'Debug Notification',
      'This is a debug notification triggered on Save Times',
      notificationDetails,
    );
    print("Debug notification sent.");
  }

  Future<void> cancelNotifications() async {
    print("Cancelling all notifications.");
    await _notificationsPlugin.cancelAll();
  }
}
