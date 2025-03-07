enum QuoteCategory { motivation, success, wisdom, happiness, any }

class Settings {
  final bool darkMode;
  final QuoteCategory quoteCategory;
  final bool notificationsEnabled;
  final int? meditationDuration;
  Settings({
    this.darkMode = false,
    this.quoteCategory = QuoteCategory.any,
    this.notificationsEnabled = true,
    this.meditationDuration,
  });

  Settings copyWith({bool? darkMode, QuoteCategory? quoteCategory, bool? notificationsEnabled, int? meditationDuration}) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      quoteCategory: quoteCategory ?? this.quoteCategory,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      meditationDuration: meditationDuration ?? this.meditationDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'quoteCategory': quoteCategory.index,
      'notificationsEnabled': notificationsEnabled,
      'meditationDuration': meditationDuration,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      darkMode: json['darkMode'] ?? false,
      quoteCategory: QuoteCategory.values[json['quoteCategory'] ?? 4],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      meditationDuration: json['meditationDuration'] ?? 60,
    );
  }

  @override
  String toString() {
    return 'Settings(darkMode: $darkMode, quoteCategory: $quoteCategory, notificationsEnabled: $notificationsEnabled, meditationDuration: $meditationDuration)';
  }
}
