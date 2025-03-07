import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    if (minutes > 0) {
      return "$minutes min ${remaining}s";
    } else {
      return "$remaining s";
    }
  }

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
            trailing: Switch(
              value: settings.darkMode,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleDarkMode();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FeatherIcons.bell),
            title: const Text('Notifications'),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleNotifications();
              },
            ),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(FeatherIcons.tag),
            title: const Text('Quote category'),
            trailing: const Icon(FeatherIcons.chevronRight, size: 20),
            onTap: () => _showCategoryPicker(context, ref, settings),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FeatherIcons.clock),
            title: const Text('Meditation duration'),
            trailing: Text(
              _formatDuration(settings.meditationDuration ?? 60),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () => _showMeditationDurationPicker(context, ref, settings),
          ),
          const Divider(),
        ],
      ),
    );
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

  void _showMeditationDurationPicker(BuildContext context, WidgetRef ref, Settings settings) {
    // Convert stored duration from seconds to minutes and seconds.
    final int currentSeconds = settings.meditationDuration ?? 60;
    int currentMinutes = currentSeconds ~/ 60;
    int currentRemainingSeconds = currentSeconds % 60;

    // Use a large number for infinite scrolling.
    const int infiniteItemCount = 600;
    // Calculate initial scroll indexes in the middle of infinite list.
    final int minutesInitialIndex = (infiniteItemCount ~/ 2) + currentMinutes;
    final int secondsInitialIndex = (infiniteItemCount ~/ 2) + currentRemainingSeconds;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Set meditation duration",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minutes Picker
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Minutes",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: minutesInitialIndex,
                                  ),
                                  itemExtent: 32,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      currentMinutes = index % 60;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                    infiniteItemCount,
                                    (int index) => Center(child: Text("${index % 60}")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Seconds Picker
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Seconds",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: secondsInitialIndex,
                                  ),
                                  itemExtent: 32,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      currentRemainingSeconds = index % 60;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                    infiniteItemCount,
                                    (int index) => Center(child: Text("${index % 60}")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      int newDuration = currentMinutes * 60 + currentRemainingSeconds;

                      if (newDuration < 1) {
                        newDuration = 1;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Minimum duration is 1 second')));
                      }

                      ref
                          .read(settingsProvider.notifier)
                          .updateSettings(settings.copyWith(meditationDuration: newDuration));
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
