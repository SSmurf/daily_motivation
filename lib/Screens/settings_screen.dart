// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme'),
            value: settings.darkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleDarkMode();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Quote Category'),
            subtitle: Text(_getCategoryName(settings.quoteCategory)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showCategoryPicker(context, ref, settings),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Daily Notifications'),
            subtitle: const Text('Get a quote notification daily'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleNotifications();
            },
          ),
        ],
      ),
    );
  }

  String _getCategoryName(QuoteCategory category) {
    switch (category) {
      case QuoteCategory.motivation:
        return 'Motivation';
      case QuoteCategory.success:
        return 'Success';
      case QuoteCategory.wisdom:
        return 'Wisdom';
      case QuoteCategory.happiness:
        return 'Happiness';
      case QuoteCategory.any:
        return 'Any Category';
    }
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref, Settings settings) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Any Category'),
                selected: settings.quoteCategory == QuoteCategory.any,
                onTap: () {
                  ref.read(settingsProvider.notifier).setQuoteCategory(QuoteCategory.any);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Motivation'),
                selected: settings.quoteCategory == QuoteCategory.motivation,
                onTap: () {
                  ref.read(settingsProvider.notifier).setQuoteCategory(QuoteCategory.motivation);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Success'),
                selected: settings.quoteCategory == QuoteCategory.success,
                onTap: () {
                  ref.read(settingsProvider.notifier).setQuoteCategory(QuoteCategory.success);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Wisdom'),
                selected: settings.quoteCategory == QuoteCategory.wisdom,
                onTap: () {
                  ref.read(settingsProvider.notifier).setQuoteCategory(QuoteCategory.wisdom);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Happiness'),
                selected: settings.quoteCategory == QuoteCategory.happiness,
                onTap: () {
                  ref.read(settingsProvider.notifier).setQuoteCategory(QuoteCategory.happiness);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
