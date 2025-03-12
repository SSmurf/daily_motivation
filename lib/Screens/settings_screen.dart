import 'package:daily_motivation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';
import '../models/notification_time.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';
import 'about_app_screen.dart';

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
        surfaceTintColor: Theme.of(context).colorScheme.surfaceDim,
      ),
      body: SafeArea(
        child: ListView(
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
              leading: const Icon(FeatherIcons.clock),
              title: const Text('Notification Times'),
              subtitle: Text(
                settings.notificationTimes.isEmpty
                    ? 'No times selected'
                    : settings.notificationTimes.map((time) => time.toString()).join(', '),
              ),
              trailing: const Icon(FeatherIcons.chevronRight, size: 20),
              onTap: () => _showNotificationTimesPicker(context, ref, settings),
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
            ListTile(
              leading: const Icon(FeatherIcons.info),
              title: const Text('About'),
              trailing: const Icon(FeatherIcons.chevronRight, size: 20),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen()));
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref, Settings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                  child: Text(
                    'Select Quote Category',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children:
                        QuoteCategory.values.map((category) {
                          return _buildCategoryTile(
                            context,
                            ref,
                            category.displayName,
                            category,
                            settings.quoteCategory,
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
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
    final int currentSeconds = settings.meditationDuration ?? 60;
    int currentMinutes = currentSeconds ~/ 60;
    int currentRemainingSeconds = currentSeconds % 60;

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
                      ).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Minutes",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: currentMinutes),
                                  itemExtent: 32,
                                  looping: true,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      currentMinutes = index;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                    60,
                                    (int index) => Center(child: Text("$index")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Seconds",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: currentRemainingSeconds,
                                  ),
                                  itemExtent: 32,
                                  looping: true,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      currentRemainingSeconds = index;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                    60,
                                    (int index) => Center(child: Text("$index")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
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
                  const SizedBox(height: AppConstants.largeSpacing),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationTimesPicker(BuildContext context, WidgetRef ref, Settings settings) {
    List<NotificationTime> localTimes = settings.notificationTimes.toList();

    Future<TimeOfDay?> pickCupertinoTime() async {
      TimeOfDay? pickedTime;
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          DateTime temporaryPickedDate = DateTime.now();
          return Container(
            height: 300,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDateTime) {
                      temporaryPickedDate = newDateTime;
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    pickedTime = TimeOfDay(
                      hour: temporaryPickedDate.hour,
                      minute: temporaryPickedDate.minute,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
      return pickedTime;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    Text(
                      'Notification Times',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const Divider(),
                    Expanded(
                      child:
                          localTimes.isEmpty
                              ? Center(
                                child: Text(
                                  'No times selected',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: localTimes.length,
                                itemBuilder: (context, index) {
                                  final time = localTimes[index];
                                  return ListTile(
                                    title: Text(time.toString()),
                                    trailing: IconButton(
                                      icon: const Icon(FeatherIcons.trash2),
                                      onPressed: () {
                                        setState(() {
                                          localTimes.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await pickCupertinoTime();
                        if (pickedTime != null) {
                          setState(() {
                            localTimes.add(
                              NotificationTime(hour: pickedTime.hour, minute: pickedTime.minute),
                            );
                            localTimes.sort((a, b) {
                              if (a.hour == b.hour) {
                                return a.minute.compareTo(b.minute);
                              }
                              return a.hour.compareTo(b.hour);
                            });
                          });
                        }
                      },
                      child: const Text('Add Time'),
                    ),
                    const SizedBox(height: AppConstants.mediumSpacing),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(settingsProvider.notifier)
                            .updateSettings(settings.copyWith(notificationTimes: localTimes));
                        Navigator.pop(context);
                      },
                      child: const Text('Save Times'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
