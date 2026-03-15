import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/data/dummy_data.dart';
import 'package:food_recipe_app/data/mock_case.dart';
import 'package:food_recipe_app/widget/dialog/mock_picker.dart';
import 'package:http/http.dart';

class MockServices {
  late final List<MockCase> defaultCase = [
    MockCase(
      name: "token expired", 
      description: "AccessToken expired or server error", 
      response: Future<Response>.sync(() {
        return Response(jsonEncode({}), 401);
      })
    ),
    MockCase(
      name: "No internet connection",
      description: "Check your internet connection and try again",
      response: Future<Response?>.sync(() {
        return Future.error(SocketException("No socket available"));
      })
    ),
    MockCase(
      name: "TimeOut", 
      description: "Time out when call data from firebase", 
      response: Future<Response?>.sync(() async {
        await Future.delayed(const Duration(seconds: 5));
        return Future.error(TimeoutException("Time out"));
      })
    )
  ];
  late final Map<String, List<MockCase>> listOfMockAction = {
    "allFoodRecipe" : getRecipeCase,
  }; 
  late final List<MockCase> getRecipeCase = [
    MockCase(
      name: "Success", 
      description: "Get food data success", 
      response: Future<Response>.sync((){
        return Response(jsonEncode(foodData), 200);
      })
    ),
    MockCase(
      name: "Failed", 
      description: "Get food data failed", 
      response: Future<Response>.sync((){
        return Response(jsonEncode({}), 400);
      })
    ),
  ];
  Future<Future<Response?>?> showMockPicker(BuildContext context, String act) async{
    final listCase = (listOfMockAction[act] ?? [])..addAll(defaultCase);
    return await showDialog<Future<Response>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MockPicker(listCase, act)
    );
  }
}