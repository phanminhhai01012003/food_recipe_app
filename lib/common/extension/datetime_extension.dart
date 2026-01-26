import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get ddmmyyyy {
    try {
      return DateFormat("dd/MM/yyyy").format(this);
    } catch (e) {
      return "dd/MM/yyyy";
    }
  }
}