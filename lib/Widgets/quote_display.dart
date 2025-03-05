// widgets/quote_display.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';

class QuoteDisplay extends StatelessWidget {
  final AsyncValue<Quote> quoteState;

  const QuoteDisplay({super.key, required this.quoteState});

  @override
  Widget build(BuildContext context) {
    return quoteState.when(
      data: (quote) => _buildQuote(context, quote),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => _buildError(context, error),
    );
  }

  Widget _buildQuote(BuildContext context, Quote quote) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '"${quote.text}"',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '— ${quote.author}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.right,
            ),
            if (quote.category != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(quote.category!),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 60),
        const SizedBox(height: 16),
        Text('Failed to load quote', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(error.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
