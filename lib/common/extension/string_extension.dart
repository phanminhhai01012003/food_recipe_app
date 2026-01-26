import 'package:intl/intl.dart';

extension StringExtension on String {
  String get priceFormat {
    try {
      return NumberFormat('#,###').format(this).replaceAll(',', '.');
    } catch (e) {
      return "";
    }
  }
}