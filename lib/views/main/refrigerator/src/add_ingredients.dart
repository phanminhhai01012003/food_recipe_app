import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/datetime_extension.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/convert.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/model/ingredient_model.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/views/main/add_edit_food/widget/file_chosen_widget.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_date_picker.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class AddIngredients extends StatefulWidget {
  const AddIngredients({super.key});

  @override
  State<AddIngredients> createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  File? file;
  String fileUrl = "";
  final unitController = TextEditingController();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final mfgController = TextEditingController();
  final expController = TextEditingController();
  void add(FridgeState state) async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    if(titleController.text.isEmpty || amountController.text.isEmpty || mfgController.text.isEmpty || expController.text.isEmpty || unitController.text.isEmpty){
      Message.showToast("infoEmpty".tr());
      context.loaderOverlay.hide();
      return;
    }else{
      if (file != null) {
        fileUrl = await imageServices.uploadImage(context, file, ingredientFolder);
      }
      IngredientModel ingredientModel = IngredientModel(
        ingredientId: generateRandomString(20), 
        ingredientName: titleController.text, 
        ingredientImage: file == null && fileUrl.isEmpty ? foodDefaultImage : fileUrl, 
        userId: currentUser.uid, 
        originalAmount: double.parse(amountController.text), 
        consumption: 0.0, 
        unit: unitController.text, 
        mfg: DateTime.parse(mfgController.text), 
        exp: DateTime.parse(expController.text)
      );
      state.addIngredientsToFridge(ingredientModel);
      context.loaderOverlay.hide();
      Message.showScaffoldMessage(context, "addIngredientSuccess".tr(), AppColors.green);
      Navigator.pop(context);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    amountController.dispose();
    unitController.dispose();
    mfgController.dispose();
    expController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fridge = context.read<FridgeState>();
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
            onPressed: () => add(fridge), 
            icon: Icon(Icons.check_circle, size: 20)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, checkDeviceRoute(AIpage)),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        shape: CircleBorder(),
        child: Icon(Icons.auto_awesome, size: 25),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Center(
              child: FileChosenWidget(
                file: file, 
                fileUrl: fileUrl, 
                onTap: () async {
                  final filePicked = await showImagePickerModal(context, false);
                  if (filePicked != null){
                    setState(() {
                      file = filePicked;
                    });
                  }
                },                
              ),
            ),
            SizedBox(height: 20),
            Text("ingredientName".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: titleController,
              cursorColor: AppColors.blue,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.green)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),
                hintText: "ingredientsInput".tr(),
                hintStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "amount".tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 33,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: amountController,
                        textAlign: TextAlign.center,
                        cursorColor: AppColors.blue,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
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
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "unit".tr(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 33,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: unitController,
                        textAlign: TextAlign.center,
                        cursorColor: AppColors.blue,
                        keyboardType: TextInputType.text,
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
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Text("mfg".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: mfgController,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500
              ),
              readOnly: true,
              onTap: (){
                if (Platform.isAndroid) {
                  showAndroidDate(
                    context, 
                    "mfgSelection".tr(), 
                    (value){
                      setState(() {
                        mfgController.text = value.ddmmyyyy;
                      });
                    }
                  );
                } else {
                  showIosDate(
                    context, 
                    (value) {
                      setState(() {
                        mfgController.text = value.ddmmyyyy;
                      });
                    }
                  );
                }
              },
              decoration: InputDecoration(
                hintText: "dd/MM/yyyy",
                hintStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.green)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),    
              ),
            ),
            SizedBox(height: 20),
            Text("exp".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: expController,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500
              ),
              readOnly: true,
              onTap: (){
                if (Platform.isAndroid) {
                  showAndroidDate(
                    context, 
                    "expSelection".tr(), 
                    (value){
                      setState(() {
                        expController.text = value.ddmmyyyy;
                      });
                    }
                  );
                } else {
                  showIosDate(
                    context, 
                    (value) {
                      setState(() {
                        expController.text = value.ddmmyyyy;
                      });
                    }
                  );
                }
              },
              decoration: InputDecoration(
                hintText: "dd/MM/yyyy",
                hintStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.green)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.secondary)
                ),    
              ),
            )
          ],
        ),
      ),
    );
  }
}