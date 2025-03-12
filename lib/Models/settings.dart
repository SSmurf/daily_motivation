import 'notification_time.dart';

enum QuoteCategory {
  any,
  business,
  change,
  character,
  competition,
  education,
  famousQuotes,
  film,
  freedom,
  friendship,
  future,
  happiness,
  history,
  humorous,
  inspirational,
  life,
  love,
  motivational,
  philosophy,
  politics,
  science,
  sports,
  success,
  technology,
  virtue,
  wisdom,
}

extension QuoteCategoryExtension on QuoteCategory {
  String get slug {
    switch (this) {
      case QuoteCategory.any:
        return '';
      case QuoteCategory.famousQuotes:
        return 'famous-quotes';
      default:
        return name.toLowerCase();
    }
  }

  String get displayName {
    switch (this) {
      case QuoteCategory.any:
        return 'Any Category';
      case QuoteCategory.famousQuotes:
        return 'Famous Quotes';
      default:
        return name.substring(0, 1).toUpperCase() +
            name.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}');
    }
  }
}

class Settings {
  final bool darkMode;
  final QuoteCategory quoteCategory;
  final bool notificationsEnabled;
  final int? meditationDuration;
  final List<NotificationTime> notificationTimes;

  Settings({
    this.darkMode = true,
    this.quoteCategory = QuoteCategory.any,
    this.notificationsEnabled = true,
    this.meditationDuration,
    this.notificationTimes = const [],
  });

  Settings copyWith({
    bool? darkMode,
    QuoteCategory? quoteCategory,
    bool? notificationsEnabled,
    int? meditationDuration,
    List<NotificationTime>? notificationTimes,
  }) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      quoteCategory: quoteCategory ?? this.quoteCategory,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      meditationDuration: meditationDuration ?? this.meditationDuration,
      notificationTimes: notificationTimes ?? this.notificationTimes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'quoteCategory': quoteCategory.index,
      'notificationsEnabled': notificationsEnabled,
      'meditationDuration': meditationDuration,
      'notificationTimes': notificationTimes.map((e) => e.toJson()).toList(),
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      darkMode: json['darkMode'] ?? true,
      quoteCategory: QuoteCategory.values[json['quoteCategory'] ?? 0],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      meditationDuration: json['meditationDuration'] ?? 60,
      notificationTimes:
          json['notificationTimes'] != null
              ? List<NotificationTime>.from(
                (json['notificationTimes'] as List).map((e) => NotificationTime.fromJson(e)),
              )
              : const [],
    );
  }

  @override
  String toString() {
    return 'Settings(darkMode: $darkMode, quoteCategory: $quoteCategory, notificationsEnabled: $notificationsEnabled, meditationDuration: $meditationDuration, notificationTimes: $notificationTimes)';
  }
}
