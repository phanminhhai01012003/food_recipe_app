import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/food_display_widget/food_display_grid.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';

class AllFoodByDate extends StatefulWidget {
  final bool isDescending;
  const AllFoodByDate({super.key, required this.isDescending});

  @override
  State<AllFoodByDate> createState() => _AllFoodByDateState();
}

class _AllFoodByDateState extends State<AllFoodByDate> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: foodServices.getFoodByDate(context, widget.isDescending), 
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
                hitTestBehavior: HitTestBehavior.translucent,
                clipBehavior: Clip.hardEdge,
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