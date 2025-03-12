import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/notification_time.dart';
import 'quote_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    debugPrint("NotificationService initialized.");

    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint("Notification permission granted.");
    } else {
      debugPrint("Notification permission not granted: $status");
    }
  }

  Future<void> scheduleDailyNotifications({
    required bool enabled,
    required List<NotificationTime> times,
  }) async {
    await cancelNotifications();
    if (!enabled || times.isEmpty) {
      debugPrint("No notifications scheduled. Enabled: $enabled, Times count: ${times.length}");
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_motivation',
      'Daily Motivation',
      channelDescription: 'Daily motivational quotes',
      importance: Importance.high,
    );

    final quoteService = QuoteService();
    const int daysToSchedule = 14;
    final int totalNotifications = daysToSchedule * times.length;

    try {
      final quotes = await quoteService.getRandomQuotes(limit: totalNotifications);

      for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
        for (int i = 0; i < times.length; i++) {
          final time = times[i];
          final now = DateTime.now();
          DateTime scheduledBase = DateTime(now.year, now.month, now.day).add(Duration(days: dayOffset));

          DateTime notificationDate = DateTime(
            scheduledBase.year,
            scheduledBase.month,
            scheduledBase.day,
            time.hour,
            time.minute,
          );

          final effectiveDate =
              (dayOffset == 0 && notificationDate.isBefore(now))
                  ? notificationDate.add(const Duration(days: 1))
                  : notificationDate;

          final int quoteIndex = dayOffset * times.length + i;
          final notificationBody = quotes[quoteIndex % quotes.length].text;
          final notificationId = dayOffset * 100 + i;

          debugPrint(
            "Scheduling notification ID $notificationId at $effectiveDate with quote: $notificationBody",
          );

          await _notificationsPlugin.zonedSchedule(
            notificationId,
            'Daily Motivation',
            notificationBody,
            tz.TZDateTime.from(effectiveDate, tz.local),
            NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails()),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching quotes for notifications: $e");
    }
  }

  Future<void> sendDebugNotification() async {
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
    debugPrint("Debug notification sent.");
  }

  Future<void> cancelNotifications() async {
    debugPrint("Cancelling all notifications.");
    await _notificationsPlugin.cancelAll();
  }
}
