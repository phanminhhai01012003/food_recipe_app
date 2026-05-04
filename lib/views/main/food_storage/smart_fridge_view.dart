import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/model/ingredient_model.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/views/main/refrigerator/widgets/product_list.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:provider/provider.dart';

class SmartFridgeView extends StatefulWidget {
  const SmartFridgeView({super.key});

  @override
  State<SmartFridgeView> createState() => _SmartFridgeViewState();
}

class _SmartFridgeViewState extends State<SmartFridgeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          "smartFridge".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Selector<FridgeState, List<IngredientModel>>(
        selector: (context, state) => state.fridge,
        shouldRebuild: (previous, next) => previous != next,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return NoData();
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            shrinkWrap: true,
            hitTestBehavior: HitTestBehavior.translucent,
            clipBehavior: Clip.hardEdge,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) => ProductList(ingredient: value[index])
          );
        },
      ),
    );
  }
}