import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(FeatherIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(FeatherIcons.moon),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme'),
            trailing: Switch(
              value: settings.darkMode,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleDarkMode();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FeatherIcons.tag),
            title: const Text('Quote Category'),
            subtitle: Text(_getCategoryName(settings.quoteCategory)),
            trailing: const Icon(FeatherIcons.chevronRight, size: 20),
            onTap: () => _showCategoryPicker(context, ref, settings),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FeatherIcons.bell),
            title: const Text('Daily Notifications'),
            subtitle: const Text('Get a quote notification daily'),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleNotifications();
              },
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Select Quote Category', style: Theme.of(context).textTheme.titleLarge),
              ),
              const Divider(),
              _buildCategoryTile(context, ref, 'Any Category', QuoteCategory.any, settings.quoteCategory),
              _buildCategoryTile(
                context,
                ref,
                'Motivation',
                QuoteCategory.motivation,
                settings.quoteCategory,
              ),
              _buildCategoryTile(context, ref, 'Success', QuoteCategory.success, settings.quoteCategory),
              _buildCategoryTile(context, ref, 'Wisdom', QuoteCategory.wisdom, settings.quoteCategory),
              _buildCategoryTile(context, ref, 'Happiness', QuoteCategory.happiness, settings.quoteCategory),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    WidgetRef ref,
    String title,
    QuoteCategory category,
    QuoteCategory currentCategory,
  ) {
    final isSelected = category == currentCategory;

    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(FeatherIcons.check) : null,
      selected: isSelected,
      onTap: () {
        ref.read(settingsProvider.notifier).setQuoteCategory(category);
        Navigator.pop(context);
      },
    );
  }
}
