import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food/ingredient_model.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/load_data/no_data.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class AddFromFridge extends StatefulWidget {
  const AddFromFridge({super.key});

  @override
  State<AddFromFridge> createState() => _AddFromFridgeState();
}

class _AddFromFridgeState extends State<AddFromFridge> {
  HashSet<IngredientModel> ingredientList = HashSet<IngredientModel>();
  List<String> added = [];
  final consumptionController = TextEditingController();
  bool showError = false;
  void toggle(IngredientModel ingredient){
    if (ingredientList.contains(ingredient)){
      ingredientList.remove(ingredient);
    } else {
      ingredientList.add(ingredient);
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              ShowYesnoDialog.checkDeviceDialog(
                context, 
                title: "discardChangeTitle".tr(), 
                content: "discardChangeDesc".tr(), 
                onAcceptTap: () async{
                  Navigator.pop(context);
                  await Future.delayed(Duration(seconds: 1),(){
                    Navigator.pop(context);
                  });
                }, 
                onCancelTap: () => Navigator.pop(context)
              );
            }, 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        title: Text("addIngredient".tr()),
        actions: [
          IconButton(
            onPressed: () async{
              if (consumptionController.text.isEmpty) return;
              context.loaderOverlay.show();
              await Future.delayed(Duration(seconds: 2));
              final snapshot = await fridgeCollection.where("userId", isEqualTo: currentUser.uid).get();
              final data = snapshot.docs.map((e) => IngredientModel.fromJson(e.data()));
              for (var doc in data) {
                double remainingAmount = doc.originalAmount - doc.consumption; 
                double remainingRequired = remainingAmount - double.parse(consumptionController.text);
                if (remainingRequired <= 0.0) {
                  setState(() {
                    showError = true;
                  });
                  context.loaderOverlay.hide();
                  return;
                }
                if (doc.exp.isBefore(DateTime.now())){
                  Message.showScaffoldMessage(context, "expiredError".tr(), AppColors.red);
                  context.loaderOverlay.hide();
                  return;
                }
                await fridgeCollection.doc(doc.ingredientId).update({"consumption": consumptionController.text});
                for (var item in ingredientList) {
                  String result = "${consumptionController.text}${item.unit} ${item.ingredientName}";
                  added.add(result);
                }
              }
              Navigator.pop(context, added);
            }, 
            icon: Icon(Icons.check_circle, size: 20)
          )
        ],
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
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: value.length ~/ 2,
            itemBuilder: (context, index) => Column(
              children: [
                GestureDetector(
                  onTap:() => toggle(value[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ingredientList.contains(value[index]) ? AppColors.blue : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: value[index].ingredientImage,
                            progressIndicatorBuilder: (context, url, progress) => Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                color: AppColors.yellow,
                              )
                            ),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.error,
                                size: 20,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          value[index].ingredientName,
                          style: TextStyle(
                            color: ingredientList.contains(value[index]) ? AppColors.white : theme.colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  child: SizedBox(
                    height: 33,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: consumptionController,
                      textAlign: TextAlign.center,
                      cursorColor: AppColors.blue,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colorScheme.secondary)
                        ),
                      ),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14
                      )
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: showError,
                  child: Text(
                    "errorIngredient".tr(),
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                )
              ],
            )
          );
        },
      ),
    );
  }
}