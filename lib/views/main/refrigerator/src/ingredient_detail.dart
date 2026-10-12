import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/food/ingredient_model.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/full_screen_image/show_image_sheet.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:provider/provider.dart';

class IngredientDetail extends StatefulWidget {
  final IngredientModel ingredient;
  const IngredientDetail({super.key, required this.ingredient});

  @override
  State<IngredientDetail> createState() => _IngredientDetailState();
}

class _IngredientDetailState extends State<IngredientDetail> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async => await showImageChoiceBottomSheet(context, widget.ingredient.ingredientImage),
                  child: Hero(
                    tag: widget.ingredient.ingredientImage,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.ingredient.ingredientImage),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: Icon(
                        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                        size: 20,
                        color: AppColors.white,
                      )
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theme.colorScheme.primary
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ingredient.ingredientName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${"originalAmount".tr()}: ${widget.ingredient.originalAmount}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${"consumption".tr()}: ${widget.ingredient.consumption}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${"remain".tr()}: ${widget.ingredient.originalAmount - widget.ingredient.consumption}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${"mfg".tr()}: ${widget.ingredient.mfg}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${"exp".tr()}: ${widget.ingredient.exp}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${"status".tr()}${widget.ingredient.exp.isBefore(DateTime.now()) ? "expired".tr() : "canUse".tr()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                          ),
                          onPressed: () => Navigator.push(context, checkDeviceRoute(editIngredient(widget.ingredient))), 
                          child: Text(
                            "edit".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                            ),
                          )
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                          ),
                          onPressed: () {
                            ShowYesnoDialog.checkDeviceDialog(
                              context, 
                              title: "deleteIngredientTitle".tr(), 
                              content: "deleteIngredientDesc".tr(), 
                              onAcceptTap: () {
                                context.read<FridgeState>().removeIngredientsFromFridge(widget.ingredient);
                                Message.showScaffoldMessage(context, "deleteSuccess".tr(), AppColors.green);
                                Navigator.pop(context);
                              }, 
                              onCancelTap: () => Navigator.pop(context)
                            );
                          }, 
                          child: Text(
                            "delete".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                            ),
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}