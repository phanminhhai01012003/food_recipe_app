import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';

class FoodRecipeDisplay extends StatefulWidget {
  final Stream stream;
  const FoodRecipeDisplay({super.key, required this.stream});

  @override
  State<FoodRecipeDisplay> createState() => _FoodRecipeDisplayState();
}

class _FoodRecipeDisplayState extends State<FoodRecipeDisplay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream, 
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadData(isList: false);
        } else {
          List<FoodModel> foods = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: foods.length / 2 as int,
            itemBuilder: (context, index) => FoodDisplayGrid(food: foods[index]),
          );
        }
      }
    );
  }
}