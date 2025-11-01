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
          return SizedBox(
            height: 200,
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              hitTestBehavior: HitTestBehavior.translucent,
              clipBehavior: Clip.hardEdge,
              itemCount: (foods.length / 2).toInt(),
              itemBuilder: (context, index) => FoodDisplayGrid(food: foods[index]),
            ),
          );
        }
      }
    );
  }
}