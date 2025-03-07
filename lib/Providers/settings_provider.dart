import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return SettingsNotifier(storageService);
});

class SettingsNotifier extends StateNotifier<Settings> {
  final StorageService _storageService;

  SettingsNotifier(this._storageService) : super(Settings()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await _storageService.getSettings();
    if (mounted) {
      state = settings;
    }
  }

  Future<void> updateSettings(Settings settings) async {
    if (mounted) {
      state = settings;
    }
    await _storageService.saveSettings(settings);
  }

  Future<void> toggleDarkMode() async {
    if (mounted) {
      final newSettings = state.copyWith(darkMode: !state.darkMode);
      await updateSettings(newSettings);
    }
  }

  Future<void> setQuoteCategory(QuoteCategory category) async {
    if (mounted) {
      final newSettings = state.copyWith(quoteCategory: category);
      await updateSettings(newSettings);
    }
  }

  Future<void> toggleNotifications() async {
    if (mounted) {
      final newSettings = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
      await updateSettings(newSettings);
    }
  }
}
