import 'dart:convert';

import 'package:food_recipe_app/data/dummy_data.dart';
import 'package:food_recipe_app/model/mock_case.dart';
import 'package:http/http.dart';

class MockServices {
  final List<MockCase> getRecipeCase = [
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
}