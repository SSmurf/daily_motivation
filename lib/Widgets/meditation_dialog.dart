import 'dart:async';
import 'package:daily_motivation/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class MeditationDialog extends StatefulWidget {
  final int duration;

  const MeditationDialog({super.key, required this.duration});

  @override
  State<MeditationDialog> createState() => _MeditationDialogState();
}

class _MeditationDialogState extends State<MeditationDialog> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds == 0) {
        setState(() {
          _completed = true;
        });
        _timer?.cancel();
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 500);
        }
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formattedTime() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 250,
        height: 350,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.extraLargeSpacing,
            horizontal: AppConstants.mediumSpacing,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _completed ? "Well done!" : "Meditation",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: _completed ? 1 : 1 - (_remainingSeconds / widget.duration),
                        strokeWidth: 8,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _completed ? "" : _formattedTime(),
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
                label: const Text('Dismiss'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
