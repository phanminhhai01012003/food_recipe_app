import 'dart:math';

String generateRandomString(int length){
  final rand = Random();
  const availableChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(
    Iterable.generate(
      length, 
      (_) => availableChars.codeUnitAt(rand.nextInt(availableChars.length))
    )
  );
}

int generateRandomNumber(int max){
  final rand = Random();
  return rand.nextInt(max);
}

Duration convertStrToDur(String time) {
  try {
    List<String> split = time.split(":");
    int dys = int.parse(split[0]);
    int hrs = int.parse(split[1]);
    int mins = int.parse(split[2]);
    int secs = int.parse(split[3]);
    Duration res = Duration(days: dys, hours: hrs, minutes: mins, seconds: secs);
    return res;
  } catch (e) {
    return Duration.zero;
  }
}