extension Extension on String {
  String twoDigits(int n) => n >= 10 ? "$n" : "0$n";
  String get ddhhmmss {
    final duration = Duration();
    String days = twoDigits(duration.inDays.remainder(31));
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days:$hours:$minutes:$seconds";
  }
}