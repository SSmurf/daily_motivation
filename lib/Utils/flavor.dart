import 'package:flutter/material.dart';

enum Flavor { development, release }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color colorOverride;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color colorOverride = Colors.blue,
    bool shouldShowDebugBanner = true,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: flavor.name,
      colorOverride: colorOverride,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.colorOverride,
  });

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool get isDevelopment => _instance!.flavor == Flavor.development;
  static bool get isRelease => _instance!.flavor == Flavor.release;
}
