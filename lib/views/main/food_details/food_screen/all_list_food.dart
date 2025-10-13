import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_services.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';

class AllListFood extends StatefulWidget {
  const AllListFood({super.key});

  @override
  State<AllListFood> createState() => _AllListFoodState();
}

class _AllListFoodState extends State<AllListFood> {
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
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back, size: 20)
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _foodServices.getFood(context), 
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError){
              return const SizedBox();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadData(isList: false);
            } else {
              List<FoodModel> foodList = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                hitTestBehavior: HitTestBehavior.translucent,
                clipBehavior: Clip.hardEdge,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
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