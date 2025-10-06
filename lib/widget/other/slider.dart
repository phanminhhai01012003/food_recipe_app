import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_list.dart';

class SliderWidget extends StatelessWidget {
  final FoodModel food;
  final List<Widget> children;
  const SliderWidget({super.key, required this.food, required this.children});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(food.foodId),
      endActionPane: ActionPane(
        motion: ScrollMotion(), 
        children: children
      ),
      child: FoodDisplayList(food: food),
    );
  }
}