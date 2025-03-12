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

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
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

    try {
      final quotes = await quoteService.getRandomQuotes(limit: times.length);

      for (int i = 0; i < times.length; i++) {
        final time = times[i];
        final now = DateTime.now();
        final scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
        final effectiveDate = scheduledDate.isBefore(now)
            ? scheduledDate.add(const Duration(days: 1))
            : scheduledDate;

        final notificationBody = quotes[i % quotes.length].text;
        debugPrint(
          "Scheduling notification $i at $effectiveDate for time: $time with quote: $notificationBody",
        );

        await _notificationsPlugin.zonedSchedule(
          i,
          'Daily Motivation',
          notificationBody,
          tz.TZDateTime.from(effectiveDate, tz.local),
          NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails()),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
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
