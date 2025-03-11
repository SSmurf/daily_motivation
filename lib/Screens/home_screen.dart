import 'package:daily_motivation/Providers/settings_provider.dart';
import 'package:daily_motivation/Widgets/meditation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_display.dart';
import '../utils/constants.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteState = ref.watch(quoteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        leading: IconButton(
          icon: const Icon(FeatherIcons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.share),
            onPressed: () => _shareQuoteText(context, quoteState),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumSpacing,
              vertical: AppConstants.largeSpacing,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                QuoteDisplay(quoteState: quoteState),
                const Spacer(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ref.read(settingsProvider.notifier).loadSettings();
                          final meditationDuration = ref.read(settingsProvider).meditationDuration ?? 60;
                          _startMeditation(context, meditationDuration);
                        },
                        icon: const Icon(FeatherIcons.moon),
                        label: const Text('Meditate'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.largeSpacing),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(quoteProvider.notifier).fetchQuote();
                        },
                        icon: const Icon(FeatherIcons.refreshCw),
                        label: const Text('New Quote'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareQuoteText(BuildContext context, AsyncValue<Quote> quoteState) {
    if (quoteState is! AsyncData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No quote available to share')));
      return;
    }

    final quote = quoteState.value;
    final textToShare = '"${quote!.text}" — ${quote.author}';
    Share.share(textToShare, subject: 'Daily Motivation');
  }

  void _startMeditation(BuildContext context, int meditationDuration) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => MeditationDialog(duration: meditationDuration),
    );
  }
}
