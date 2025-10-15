import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';

class FoodListWithTag extends StatefulWidget {
  final String categories;
  const FoodListWithTag({super.key, required this.categories});

  @override
  State<FoodListWithTag> createState() => _FoodListWithTagState();
}

class _FoodListWithTagState extends State<FoodListWithTag> {
  final _foodServices = FoodServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text("PMH Food Recipe",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _foodServices.getFoodByTag(context, widget.categories), 
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError){
              return const SizedBox();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadData(isList: false);
            } else {
              List<FoodModel> foodList = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                hitTestBehavior: HitTestBehavior.translucent,
                clipBehavior: Clip.hardEdge,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8
                ),
                itemCount: foodList.length, 
                itemBuilder: (context, index) => FoodDisplayGrid(food: foodList[index])
              );
            }
          }
        ),
      ),
    );
  }
}