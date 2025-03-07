// providers/quote_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import 'settings_provider.dart';
import '../models/settings.dart';

final quoteServiceProvider = Provider<QuoteService>((ref) {
  return QuoteService();
});

final quoteProvider = StateNotifierProvider<QuoteNotifier, AsyncValue<Quote>>((ref) {
  final quoteService = ref.watch(quoteServiceProvider);
  final settings = ref.watch(settingsProvider);
  return QuoteNotifier(quoteService, settings);
});

class QuoteNotifier extends StateNotifier<AsyncValue<Quote>> {
  final QuoteService _quoteService;
  final Settings _settings;

  QuoteNotifier(this._quoteService, this._settings) : super(const AsyncValue.loading()) {
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    if (mounted) {
      state = const AsyncValue.loading();
    }

    try {
      final category =
          _settings.quoteCategory == QuoteCategory.any
              ? null
              : _settings.quoteCategory.toString().split('.').last;

      final quote = await _quoteService.getRandomQuote(category: category);

      if (mounted) {
        state = AsyncValue.data(quote);
      }
    } catch (e, stack) {
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}
