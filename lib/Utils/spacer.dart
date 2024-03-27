import 'package:flutter/material.dart';

class HSpacer extends StatelessWidget {
  final double size;
  const HSpacer({super.key, this.size = 16});

  factory HSpacer.xs() {
    return HSpacer(
      size: 4,
    );
  }
  factory HSpacer.sm() {
    return HSpacer(
      size: 8,
    );
  }
  factory HSpacer.md() {
    return HSpacer(
      size: 16,
    );
  }
  factory HSpacer.lg() {
    return HSpacer(
      size: 24,
    );
  }
  factory HSpacer.xl() {
    return HSpacer(
      size: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
    );
  }
}

class VSpacer extends StatelessWidget {
  final double size;
  const VSpacer({super.key, this.size = 16});

  factory VSpacer.xs() {
    return VSpacer(
      size: 4,
    );
  }
  factory VSpacer.sm() {
    return VSpacer(
      size: 8,
    );
  }
  factory VSpacer.md() {
    return VSpacer(
      size: 16,
    );
  }
  factory VSpacer.lg() {
    return VSpacer(
      size: 24,
    );
  }
  factory VSpacer.xl() {
    return VSpacer(
      size: 32,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
    );
  }
}
