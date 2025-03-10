import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

class AppConstants {
  static const String appName = 'Daily Motivation';
  static const String appVersion = '1.0.0';
  
  static const IconData refreshIcon = FeatherIcons.refreshCw;
  static const IconData settingsIcon = FeatherIcons.settings;
  static const IconData themeIcon = FeatherIcons.moon;
  static const IconData notificationIcon = FeatherIcons.bell;
  static const IconData categoryIcon = FeatherIcons.tag;
  static const IconData backIcon = FeatherIcons.arrowLeft;
  
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  static final BorderRadius smallBorderRadius = BorderRadius.circular(8.0);
  static final BorderRadius mediumBorderRadius = BorderRadius.circular(16.0);
  static final BorderRadius largeBorderRadius = BorderRadius.circular(24.0);
  
  static final List<Map<String, String>> fallbackQuotes = [
    {
      "text": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs"
    },
    {
      "text": "Life is what happens when you're busy making other plans.",
      "author": "John Lennon"
    },
    {
      "text": "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt"
    },
    {
      "text": "Success is not final, failure is not fatal: It is the courage to continue that counts.",
      "author": "Winston Churchill"
    },
    {
      "text": "The best way to predict the future is to create it.",
      "author": "Peter Drucker"
    }
  ];
}
