import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food/cookbook_model.dart';
import 'package:food_recipe_app/model/food/food_model.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/views/main/cookbook/widget/cookbook_list.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class CookbookSelection extends StatefulWidget {
  final FoodModel food;
  const CookbookSelection({super.key, required this.food});

  @override
  State<CookbookSelection> createState() => _CookbookSelectionState();
}

class _CookbookSelectionState extends State<CookbookSelection> {
  void onMultiSelect(CookbookModel cookbook){
    if (cookbook.foodsList.contains(widget.food)){
      cookbook.foodsList.remove(widget.food);
    } else {
      cookbook.foodsList.add(widget.food);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<CookbookState>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.primary,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.secondary,
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              children: [
                Text(
                  "addFoodToCookbook".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(height: 20),
                Builder(
                  builder: (context) {
                    if (value.bookProducts.isEmpty) {
                      return NoData();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      hitTestBehavior: HitTestBehavior.translucent,
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: value.bookProducts.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => onMultiSelect(value.bookProducts[index]),
                          child: CookbookList(
                            cookbook: value.bookProducts[index],
                            food: widget.food,
                        )
                      )
                    );  
                  },
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                    ),
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await Future.delayed(Duration(seconds: 2));
                      for (var cookbook in value.bookProducts) {
                        context.read<CookbookState>().toggleFoodOnCookbook(cookbook, widget.food);
                      }
                      context.loaderOverlay.hide();
                      Message.showScaffoldMessage(context, "addCookbookSuccess".tr(), AppColors.green);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "add".tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ),
                )  
              ],
            ),
          ),
        );
      },
    );
  }
}