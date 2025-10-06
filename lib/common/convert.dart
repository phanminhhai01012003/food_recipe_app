import 'dart:math';

import 'package:food_recipe_app/model/food_model.dart';

String generateRandomString(int length){
  final rand = Random();
  const availableChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(Iterable.generate(length, (_) => availableChars.codeUnitAt(rand.nextInt(availableChars.length))));
}

Duration convertStrToDur(FoodModel? food) {
  String time = food!.duration;
  List<String> split = time.split(":");
  int dys = int.parse(split[0]);
  int hrs = int.parse(split[1]);
  int mins = int.parse(split[2]);
  int secs = int.parse(split[3]);
  Duration res = Duration(days: dys, hours: hrs, minutes: mins, seconds: secs);
  return res;
}