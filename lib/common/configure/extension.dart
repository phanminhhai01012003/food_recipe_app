extension Extension on Duration {
  String twoDigits(int n) => n >= 10 ? "$n" : "0$n";
  String get ddhhmmss {
    String days = twoDigits(inDays.remainder(31));
    String hours = twoDigits(inHours.remainder(24));
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));
    return "$days:$hours:$minutes:$seconds";
  }
}