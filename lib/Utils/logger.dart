import 'package:flutter/foundation.dart';
import 'flavor.dart';

class AppLogger {
  static void log(String message, {bool forceLog = false}) {
    debugPrint(message);
  }

  static void info(String message) {
    log('[INFO] $message');
  }

  static void debug(String message) {
    log('[DEBUG] $message');
  }

  static void warning(String message) {
    log('[WARNING] $message');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    final errorMsg = error != null ? '$message\nError: $error' : message;
    final fullMsg = stackTrace != null ? '$errorMsg\n$stackTrace' : errorMsg;
    log('[ERROR] $fullMsg', forceLog: true);
  }

  static void api(String message) {
    log('[API] $message');
  }

  static void performance(String message) {
    log('[PERFORMANCE] $message');
  }
}
