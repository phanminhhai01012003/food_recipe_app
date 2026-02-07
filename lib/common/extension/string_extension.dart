import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get priceFormat {
    try {
      return NumberFormat.decimalPattern().format(int.parse(this)).replaceAll(',', '.');
    } catch (e) {
      return "";
    }
  }
  String tr([String? value]){
    return translate(this, args: {"value": value});
  }
}