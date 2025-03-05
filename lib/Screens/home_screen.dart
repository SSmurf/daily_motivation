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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.share),
            onPressed: () => _shareQuoteText(context, quoteState),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              QuoteDisplay(quoteState: quoteState),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(quoteProvider.notifier).fetchQuote();
                },
                icon: const Icon(FeatherIcons.refreshCw),
                label: const Text('New Quote'),
              ),
              const SizedBox(height: AppConstants.extraLargeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  void _shareQuoteText(BuildContext context, AsyncValue<Quote> quoteState) {
    if (quoteState is! AsyncData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quote available to share')),
      );
      return;
    }

    final quote = quoteState.value;
    final textToShare = '"${quote!.text}" — ${quote.author}';
    
    Share.share(
      textToShare,
      subject: 'Daily Motivation',
    );
  }
}
