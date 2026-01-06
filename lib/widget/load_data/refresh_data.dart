import 'package:flutter/material.dart';

class RefreshData extends StatelessWidget {
  final Color? bgColor;
  final Color? fgColor;
  final double? strokeWidth;
  final Future<void> Function()? onRefresh;
  final Widget child;
  const RefreshData({
    super.key,
    this.bgColor,
    this.fgColor,
    this.strokeWidth,
    this.onRefresh,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      backgroundColor: bgColor ?? theme.colorScheme.primary,
      color: fgColor ?? theme.colorScheme.secondary,
      strokeWidth: strokeWidth ?? 1.0,
      child: child,
    );
  }
}