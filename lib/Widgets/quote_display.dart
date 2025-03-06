import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';
import '../models/quote.dart';
import '../utils/constants.dart';

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
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppConstants.mediumBorderRadius),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          children: [
            Icon(
              FeatherIcons.messageCircle,
              size: 40,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.largeSpacing),
            Text(
              '"${quote.text}"',
              style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            Text(
              '— ${quote.author}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.right,
            ),
            if (quote.category != null) ...[
              const SizedBox(height: AppConstants.smallSpacing),
              Chip(
                label: Text(quote.category!),
                backgroundColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppConstants.mediumBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          children: [
            Icon(FeatherIcons.alertCircle, color: theme.colorScheme.error, size: 60),
            const SizedBox(height: AppConstants.mediumSpacing),
            Text('Failed to load quote', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.smallSpacing),
            Text(
              'Try refreshing or check your connection',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
