import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static Color green = Colors.green.shade400;
  static Color red = Colors.red.shade500;
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color blue = Colors.blue.shade700;
  static Color grey = Colors.grey.shade200;
  static Color yellow = Color(0xFFF2F25D);
  static Color purple = Color(0xFFBA68C8);
  static final gradient1 = LinearGradient(
    colors: [
      Color(0xFF151BE0),
      Color(0xFFD71C0E)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    transform: GradientRotation(pi/2)
  );
  static final gradient2 = LinearGradient(
    colors: [
      Color(0xFF22D70E),
      Color(0xFFF2F25D),
      Color(0xFF151BE0),
      Color(0xFFD71C0E)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.25, 0.5, 0.75]
  );
  static final gradient3 = LinearGradient(
    colors: [
      Color(0xFFA4200C),
      Color(0xFFE870ED),
      Color(0xFF22D70E)
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    tileMode: TileMode.clamp
  );
}