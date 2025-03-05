enum QuoteCategory { motivation, success, wisdom, happiness, any }

class Settings {
  final bool darkMode;
  final QuoteCategory quoteCategory;
  final bool notificationsEnabled;

  Settings({this.darkMode = false, this.quoteCategory = QuoteCategory.any, this.notificationsEnabled = true});

  Settings copyWith({bool? darkMode, QuoteCategory? quoteCategory, bool? notificationsEnabled}) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      quoteCategory: quoteCategory ?? this.quoteCategory,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'quoteCategory': quoteCategory.index,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      darkMode: json['darkMode'] ?? false,
      quoteCategory: QuoteCategory.values[json['quoteCategory'] ?? 4],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }
}
