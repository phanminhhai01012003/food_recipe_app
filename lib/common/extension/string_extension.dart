import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get priceFormat {
    try {
      return NumberFormat('#,###').format(this).replaceAll(',', '.');
    } catch (e) {
      return "";
    }
  }
  String tr([String? value]){
    return translate(this, args: {"value": value});
  }
}