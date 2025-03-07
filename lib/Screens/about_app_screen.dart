import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../utils/constants.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FeatherIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        // backgroundColor: Theme.of(context).colorScheme.surface,
        // surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(FeatherIcons.info, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: onSurfaceColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('About', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: onSurfaceColor)),
              const SizedBox(height: 8),
              Text(
                'Daily Motivation is an app designed to inspire and motivate you every day. '
                'It provides daily quotes from various categories and includes a meditation timer to help you relax and focus.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
              ),
              const SizedBox(height: 24),
              Text(
                'Features',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: onSurfaceColor),
              ),
              const SizedBox(height: 8),
              const _FeatureItem(
                icon: FeatherIcons.messageCircle,
                title: 'Daily Quotes',
                description: 'Get inspired by quotes from various categories.',
              ),
              const _FeatureItem(
                icon: FeatherIcons.moon,
                title: 'Meditation Timer',
                description: 'Take a moment to relax with the customizable meditation timer.',
              ),
              const _FeatureItem(
                icon: FeatherIcons.share2,
                title: 'Share Quotes',
                description: 'Share your favorite quotes with friends and family.',
              ),
              const SizedBox(height: 24),
              Text('Made By', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: onSurfaceColor)),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Icon(FeatherIcons.user, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anton Pomper',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(color: onSurfaceColor),
                              ),
                              Text(
                                'Developer',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Created with ❤️ using Flutter. This app was developed as a personal project to help people stay motivated and mindful throughout their day.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© ${DateTime.now().year} Daily Motivation',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: onSurfaceColor.withAlpha(153)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: onSurfaceColor)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurfaceColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
