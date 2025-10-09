import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_list.dart';
import 'package:provider/provider.dart';

class CookbookSelection extends StatefulWidget {
  final FoodModel food;
  const CookbookSelection({super.key, required this.food});

  @override
  State<CookbookSelection> createState() => _CookbookSelectionState();
}

class _CookbookSelectionState extends State<CookbookSelection> {
  HashSet<CookbookModel> choices = HashSet();
  bool canMultiSelected = false;
  void onMultiSelect(CookbookModel cookbook){
    if (canMultiSelected){
      if (choices.contains(cookbook)){
        choices.remove(cookbook);
      } else {
        choices.add(cookbook);
      }
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back, size: 20)
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              "Bạn muốn thêm món ăn này vào đâu?",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900
              ),
            ),
            Selector<CookbookState, List<CookbookModel>>(
              selector: (context, state) => state.bookProducts,
              shouldRebuild: (previous, next) => true,
              builder: (context, value, child) {
                if (value.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error, 
                          size: 50, 
                          color: AppColors.red
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Không có dữ liệu",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: value.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => onMultiSelect(value[index]),
                    onLongPress: () {
                      canMultiSelected = true;
                      onMultiSelect(value[index]);
                    },
                    child: CookbookList(
                      cookbook: value[index],
                      food: widget.food,
                    )
                  )
                );      
              },
            )
          ],
        ),
      ),
    );
  }
}